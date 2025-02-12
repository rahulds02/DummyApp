//
//  MockFetchCategoriesUseCase.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//
import XCTest
@testable import shopStop

class MockFetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {
    var executeResult: Result<[shopStop.Category], Error>?

    func execute(completion: @escaping (Result<[shopStop.Category], Error>) -> Void) {
        guard let result = executeResult else {
            completion(.failure(NSError(domain: "NoResultSet", code: 0, userInfo: nil)))
            return
        }
        completion(result)
    }
}
