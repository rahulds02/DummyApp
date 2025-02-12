//
//  MockCategoryRepository.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//

@testable import shopStop
import Foundation


class MockCategoryRepository: CategoryRepository {
    var result: Result<[CategoryEntity], Error>? // Change to `CategoryEntity`

    func fetchCategories(completion: @escaping (Result<[CategoryEntity], Error>) -> Void) {
        if let result = result {
            completion(result)
        } else {
            let error = NSError(domain: "NoResultSet", code: 0, userInfo: nil) as Error
            completion(.failure(error))
        }
    }
}
