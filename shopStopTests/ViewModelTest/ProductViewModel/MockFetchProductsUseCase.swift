//
//  MockFetchProductsUseCase.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//
import XCTest
@testable import shopStop

class MockFetchProductsUseCase: FetchProductsUseCaseProtocol {
    var executeResult: Result<[Product], Error>? // Use `Product` instead of `ProductEntity`
    var downloadAndCacheResult: Result<Void, Error>?

    func executeAndFetch(categoryID: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let result = executeResult else {
            completion(.failure(NSError(domain: "No Result Set", code: 0, userInfo: nil)))
            return
        }
        completion(result)
    }

    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let result = downloadAndCacheResult else {
            completion(.failure(NSError(domain: "No Result Set", code: 0, userInfo: nil)))
            return
        }
        completion(result)
    }
}
