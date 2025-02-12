//
//  FetchProductUseCase.swift
//  ShopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import Foundation

protocol FetchProductsUseCaseProtocol {
    func executeAndFetch(categoryID: String, completion: @escaping (Result<[Product], Error>) -> Void)
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

class FetchProductsUseCase: FetchProductsUseCaseProtocol {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    // Fetch Products (`ProductEntity` → `Product`)**
    func executeAndFetch(categoryID: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        repository.fetchProducts(for: categoryID) { result in
            switch result {
            case .success(let productEntities):
                // Convert `ProductEntity` to `Product` Before Returning
                let products = ProductMapper.mapEntityToDomain(productEntities)
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Download and Cache Product Image**
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.downloadAndCacheImage(for: id, completion: completion)
    }
}

