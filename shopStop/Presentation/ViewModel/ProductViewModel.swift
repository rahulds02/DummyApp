//
//  ProductScrollerViewModel.swift
//  ShopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import SwiftUI

protocol ProductViewModelProtocol: ObservableObject {
    var products: [ProductEntity] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func executes(categoryID: String, completion: @escaping (Result<[ProductEntity], Error>) -> Void)
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchProducts(categoryID: String)  // New method for view-based execution
}

class ProductViewModel: ObservableObject, ProductViewModelProtocol {
    @Published var products: [ProductEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let fetchProductsUseCase: FetchProductsUseCaseProtocol

    init(fetchProductsUseCase: FetchProductsUseCaseProtocol) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }

    // Keep this for compatibility (callback-based)
    func executes(categoryID: String, completion: @escaping (Result<[ProductEntity], Error>) -> Void) {
        fetchProductsUseCase.executeAndFetch(categoryID: categoryID) { result in
            switch result {
            case .success(let products):
                let productEntities = ProductMapper.mapDomainToEntity(products)
                completion(.success(productEntities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // New version for SwiftUI-based views (state-driven)
    func fetchProducts(categoryID: String) {
        let cachedProducts = ProductCache.shared.getProducts(forCategory: categoryID)

        if !cachedProducts.isEmpty {
            self.products = cachedProducts
            self.isLoading = false
            return
        }

        self.isLoading = true
        self.errorMessage = nil

        fetchProductsUseCase.executeAndFetch(categoryID: categoryID) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedProducts):
                    let productEntities = ProductMapper.mapDomainToEntity(fetchedProducts) // Convert Product → ProductEntity
                    ProductCache.shared.setProducts(productEntities) // Store converted products
                    self.products = Array(productEntities.prefix(10)) // Assign to state
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        self.fetchProductsUseCase.downloadAndCacheImage(for: id, completion: completion)
    }
}
