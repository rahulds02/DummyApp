//
//  MockAPIService.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//

import XCTest
@testable import shopStop

// Mock API Service for Unit Testing
class MockAPIService: APIServiceProtocol {

    // Simulated API Responses
    var fetchCategoriesResult: Result<[CategoryDTO], Error>?
    var fetchProductsResult: Result<[ProductDTO], Error>?
    var downloadAndCacheImageResult: Result<Void, Error>?

    // Mock Fetch Categories
    func fetchCategories(completion: @escaping (Result<[CategoryDTO], Error>) -> Void) {
        if let result = fetchCategoriesResult {
            completion(result)
        } else {
            completion(.failure(APIError.custom("Mock Error: No Categories Data")))
        }
    }

    // Mock Fetch Products
    func fetchProducts(for categoryID: String, completion: @escaping (Result<[ProductDTO], Error>) -> Void) {
        if let result = fetchProductsResult {
            completion(result)
        } else {
            completion(.failure(APIError.custom("Mock Error: No Products Data")))
        }
    }

    // Mock Download & Cache Image
    func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = downloadAndCacheImageResult {
            completion(result)
        } else {
            completion(.failure(APIError.custom("Mock Error: Image Download Failed")))
        }
    }
}
