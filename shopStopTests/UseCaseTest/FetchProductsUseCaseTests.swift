//
//  FetchProductsUseCaseTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//

import XCTest
@testable import shopStop

class FetchProductsUseCaseTests: XCTestCase {
    var mockRepository: MockProductRepository!
    var useCase: FetchProductsUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductRepository()
        useCase = FetchProductsUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func testFetchProductsSuccess() {
        // Arrange
        let mockProducts = [
            Product(id: 1, title: "Product 1", price: 10.0, thumbnail: "url1", description: "desc", rating: 4.0, discountPercentage: 10.0, category: "Category 1"),
            Product(id: 2, title: "Product 2", price: 20.0, thumbnail: "url2", description: "desc", rating: 3.5, discountPercentage: 5.0, category: "Category 1")
        ]

        let mockProductEntities = ProductMapper.mapDomainToEntity(mockProducts)
        mockRepository.fetchProductsResult = .success(mockProductEntities) // Use correct type

        let expectation = XCTestExpectation(description: "Fetch products successfully")

        useCase.executeAndFetch(categoryID: "Category 1") { result in
            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, 2)
                XCTAssertEqual(products[0].title, "Product 1")
                XCTAssertEqual(products[1].title, "Product 2")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchProductsFailure() {
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockRepository.fetchProductsResult = .failure(mockError)

        let expectation = XCTestExpectation(description: "Fetch products failure")

        useCase.executeAndFetch(categoryID: "Category 1") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "TestError")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testDownloadAndCacheImageSuccess() {
        // Arrange
        mockRepository.downloadAndCacheImageResult = .success(())

        // Act & Assert
        let expectation = XCTestExpectation(description: "Download and cache image successfully")
        useCase.downloadAndCacheImage(for: 1) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testDownloadAndCacheImageFailure() {
        // Arrange
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockRepository.downloadAndCacheImageResult = .failure(mockError)

        // Act & Assert
        let expectation = XCTestExpectation(description: "Download and cache image failure")
        useCase.downloadAndCacheImage(for: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "TestError")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
