//
//  ProductRepository.swift
//  ShopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import Foundation
import UIKit

protocol ProductRepository {
    func fetchProducts(for categoryID: String, completion: @escaping (Result<[ProductEntity], Error>) -> Void) // Return `ProductEntity`
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

class ProductRepositoryImpl: ProductRepository {
    private let apiService: APIServiceProtocol
    private let productCache: ProductCacheProtocol

    init(apiService: APIServiceProtocol, productCache: ProductCacheProtocol) {
        self.apiService = apiService
        self.productCache = productCache
    }

    /// **Fetch products from Cache or API (Returns `ProductEntity`)**
    func fetchProducts(for categoryID: String, completion: @escaping (Result<[ProductEntity], Error>) -> Void) {
        // Check if products are already cached
        let cachedProducts = productCache.getProducts(forCategory: categoryID)

        if !cachedProducts.isEmpty {
            // Convert `CachedProduct → ProductEntity`
            let mappedProducts = cachedProducts.map { cachedProduct in
                ProductEntity(
                    id: cachedProduct.id,
                    title: cachedProduct.title,
                    price: cachedProduct.price,
                    thumbnail: cachedProduct.thumbnail, // Use correct field
                    description: cachedProduct.description,
                    rating: cachedProduct.rating,
                    discountPercentage: cachedProduct.discountPercentage,
                    category: categoryID
                )
            }
            completion(.success(mappedProducts))
            return
        }

        // Fetch from API if not cached
        apiService.fetchProducts(for: categoryID) { result in
            switch result {
            case .success(let productDTOs):
                let productEntities = ProductMapper.mapDTOToEntity(productDTOs)
                // Cache Fetched Products
                self.productCache.setProducts(productEntities)
                completion(.success(productEntities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Function to download and cache an image for a specific product ID
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        apiService.downloadAndCacheImage(for: id, completion: completion)
    }
}
