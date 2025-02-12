//
//  MockProductRepository.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//

import XCTest
@testable import shopStop

class MockProductRepository: ProductRepository {
    var fetchProductsResult: Result<[ProductEntity], Error>?
    var downloadAndCacheImageResult: Result<Void, Error>?

    func fetchProducts(for categoryID: String, completion: @escaping (Result<[ProductEntity], Error>) -> Void) {
        if let result = fetchProductsResult {
            completion(result)
        } else {
            completion(.failure(NSError(domain: "MockProductRepository", code: 0, userInfo: nil)))
        }
    }

    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = downloadAndCacheImageResult {
            completion(result)
        } else {
            completion(.failure(NSError(domain: "MockProductRepository", code: 0, userInfo: nil)))
        }
    }
}
