import Foundation
import UIKit
import SystemConfiguration

// Custom API Errors for Better Error Handling
enum APIError: Error {
    case noInternetConnection
    case requestFailed
    case invalidResponse
    case noData
    case decodingError
    case custom(String)
}

// Centralized API Endpoints
enum APIEndpoints {
    case categories
    case products(categoryID: String)
    case productDetails(productID: Int)

    // Computed Property to Get Full URL
    var url: URL {
        switch self {
        case .categories:
            return URL(string: "\(AppConstants.API.baseURL)\(AppConstants.API.categories)")!
        case .products(let categoryID):
            return URL(string: "\(AppConstants.API.baseURL)\(AppConstants.API.products)\(categoryID)")!
        case .productDetails(let productID):
            return URL(string: "\(AppConstants.API.baseURL)\(AppConstants.API.productDetails)\(productID)")!
        }
    }
}

protocol APIServiceProtocol {
    func fetchCategories(completion: @escaping (Result<[CategoryDTO], Error>) -> Void)
    func fetchProducts(for categoryID: String, completion: @escaping (Result<[ProductDTO], Error>) -> Void)
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    private let baseURL: URL
    private let session: URLSession // Dependency injection for better testing
    private let networkReachability: NetworkReachabilityProtocol

    init(baseURL: URL, session: URLSession, networkReachability: NetworkReachabilityProtocol)  {
        self.baseURL = baseURL
        self.session = session
        self.networkReachability = networkReachability
    }

    func fetchCategories(completion: @escaping (Result<[CategoryDTO], Error>) -> Void) {
        guard self.networkReachability.isInternetAvailable() else {
            completion(.failure(APIError.custom(AppConstants.Errors.noInternetConnection)))
            return
        }

        let url = APIEndpoints.categories.url

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.custom(error.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                // Decode the response as an array of Category objects
                let categories = try JSONDecoder().decode([CategoryDTO].self, from: data)
                completion(.success(categories))
            } catch {
                completion(.failure(APIError.custom(AppConstants.Errors.decodingError)))
            }
        }.resume()
    }

    // Fetch products for a specific category
    func fetchProducts(for categoryID: String, completion: @escaping (Result<[ProductDTO], Error>) -> Void) {
        guard self.networkReachability.isInternetAvailable() else {
            completion(.failure(APIError.custom(AppConstants.Errors.noInternetConnection)))// Use APIError explicitly
            return
        }
        // Check if products for this category are already cached
        let cachedProducts = ProductCache.shared.getAllProducts().filter { $0.id.description.contains(categoryID) }

        if !cachedProducts.isEmpty {
            // Map cached products back to the Product model and return them
            let mappedProducts = cachedProducts.map {
                ProductDTO(id: $0.id, title: $0.title, price: $0.price, thumbnail: $0.thumbnail, description: $0.description, rating: $0.rating, discountPercentage: $0.discountPercentage, category: $0.category)
            }
            completion(.success(mappedProducts))
            return
        }

        // Fetch products from API if not cached
        let url = APIEndpoints.products(categoryID: categoryID).url

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.custom(error.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                let productResponse = try JSONDecoder().decode(ProductCategoryDTO.self, from: data)
                let productsDTO = productResponse.products

                let productEntities = ProductMapper.mapDTOToEntity(productsDTO)

                // Cache fetched products
                ProductCache.shared.setProducts(productEntities)

                completion(.success(productsDTO))
            } catch {
                completion(.failure(APIError.custom(AppConstants.Errors.decodingError)))
            }
        }.resume()
    }

    /// Function to download and cache an image for a specific product ID
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard self.networkReachability.isInternetAvailable() else {
            completion(.failure(APIError.custom(AppConstants.Errors.noInternetConnection)))
                return
            }

            // Fetch Cached Product (Use `CachedProduct`, Not `ProductEntity`)
            guard let cachedProduct = ProductCache.shared.getCachedProduct(forKey: "\(id)"),
                  cachedProduct.thumbnailImage == nil else {
                completion(.success(())) // Image Already Cached
                return
            }

            // Use `thumbnail` Instead of `thumbnailURL`
            guard let url = URL(string: cachedProduct.thumbnailURL) else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            // Download Image
            session.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data, let uiImage = UIImage(data: data) else {
                    completion(.failure(APIError.requestFailed))
                    return
                }

                // Cache Image
                DispatchQueue.main.async {
                    ProductCache.shared.cacheThumbnail(uiImage, forProductID: "\(id)")
                    completion(.success(()))
                }
            }.resume()
        }
}
