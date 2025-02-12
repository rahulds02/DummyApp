//
//  FetchCategoriesUseCaseTests.swift
//  shopStopTests
//
//  Created by Rahul Sharma on 26/01/25.
//

import XCTest
@testable import shopStop

class FetchCategoriesUseCaseTests: XCTestCase {
    private var mockRepository: MockCategoryRepository!
    private var useCase: FetchCategoriesUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockCategoryRepository()
        useCase = FetchCategoriesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    // Fix: Use `CategoryEntity`
    func testExecute_Success() {
        let mockCategories = [
            CategoryEntity(id: "beauty", name: "Beauty", imageUrl: "https://dummyjson.com/products/category/beauty"),
            CategoryEntity(id: "fragrances", name: "Fragrances", imageUrl: "https://dummyjson.com/products/category/fragrances")
        ]
        mockRepository.result = .success(mockCategories) // Fix: Use CategoryEntity

        let expectation = XCTestExpectation(description: "Fetch categories successfully")
        useCase.execute { result in
            switch result {
            case .success(let categories):
                XCTAssertEqual(categories.count, 2)
                XCTAssertEqual(categories.first?.name, "Beauty")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Fix: Ensure Failure Case Uses Correct Type
    func testExecute_Failure() {
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockRepository.result = .failure(mockError)

        let expectation = XCTestExpectation(description: "Fetch categories fails")
        useCase.execute { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "TestError")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
