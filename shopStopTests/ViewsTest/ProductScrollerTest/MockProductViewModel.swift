//
//  MockProductViewModel.swift
//  shopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import XCTest
import SwiftUI
@testable import shopStop

class MockProductViewModel: ProductViewModel {
    var downloadAndCacheImageCalled = false
    var executesResult: Result<[ProductEntity], Error>?
    var downloadAndCacheImageResult: Result<Void, Error>?
    
    init(mockFetchProductsUseCase: FetchProductsUseCaseProtocol) {
        super.init(fetchProductsUseCase: mockFetchProductsUseCase)
    }
    
    override func downloadAndCacheImage(for id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        downloadAndCacheImageCalled = true
        
        if let result = downloadAndCacheImageResult {
            completion(result)
        } else {
            completion(.failure(NSError(domain: "MockError", code: 0, userInfo: nil)))
        }
    }
    
    override func executes(categoryID: String, completion: @escaping (Result<[ProductEntity], Error>) -> Void) {
        if let result = executesResult {
            completion(result)
        } else {
            completion(.failure(NSError(domain: "MockError", code: 0, userInfo: nil)))
        }
    }
}


