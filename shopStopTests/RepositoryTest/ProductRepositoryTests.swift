//
//  ProductRepositoryTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//


import XCTest
@testable import shopStop

class ProductRepositoryTests: XCTestCase {
    var mockAPIService: MockAPIService!
    var mockProductCache: MockProductCache!
    var productRepository: ProductRepositoryImpl!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        mockProductCache = MockProductCache()
        productRepository = ProductRepositoryImpl(apiService: mockAPIService, productCache: mockProductCache)
    }

    override func tearDown() {
        mockAPIService = nil
        mockProductCache = nil
        productRepository = nil
        super.tearDown()
    }

    // Test Fetching Products from API (Success)
    func testFetchProductsFromAPISuccess() {
        // Arrange: API returns valid products
        let apiProducts = [
            Product(id: 1, title: "Product 1", price: 10.0, thumbnail: "url1", description: "Desc", rating: 4.0, discountPercentage: 0.0, category: "Category1"),
            Product(id: 2, title: "Product 2", price: 20.0, thumbnail: "url2", description: "Desc", rating: 4.0, discountPercentage: 0.0, category: "Category1")
        ]
        let apiProductEntities = ProductMapper.mapProductToEntity(apiProducts) //Convert [Product] → [ProductEntity]
        let apiProductDTOs = ProductMapper.mapDomainToDTO(apiProducts)
        mockAPIService.fetchProductsResult = .success(apiProductDTOs)

        // Act
        let expectation = XCTestExpectation(description: "Fetch products from API")
        productRepository.fetchProducts(for: "Category1") { result in
            // Assert
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

    // Test Fetching Products from API (Failure)
    func testFetchProductsFromAPIFailure() {
        // Arrange: API returns an error
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.fetchProductsResult = .failure(mockError)

        // Act
        let expectation = XCTestExpectation(description: "Fetch products from API failure")
        productRepository.fetchProducts(for: "Category1") { result in
            // Assert
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

    // Test Fetching Products from Cache
    func testFetchProductsFromCache() {
        // Arrange: Cache contains a product
        let cachedProductEntity = ProductEntity(id: 1, title: "Cached Product", price: 15.0, thumbnail: "cachedURL", description: "Cached Desc", rating: 5.0, discountPercentage: 10.0, category: "Category1")
        mockProductCache.setProduct(cachedProductEntity, forKey: "\(cachedProductEntity.id)")

        // Act
        let expectation = XCTestExpectation(description: "Fetch products from cache")
        productRepository.fetchProducts(for: "Category1") { result in
            // Assert
            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, 1)
                XCTAssertEqual(products[0].title, "Cached Product")
                XCTAssertEqual(products[0].price, 15.0)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // Test Fetching an Empty Category (No Products)
    func testFetchEmptyCategory() {
        // Arrange: API returns no products
        mockAPIService.fetchProductsResult = .success([])

        // Act
        let expectation = XCTestExpectation(description: "Fetch empty category")
        productRepository.fetchProducts(for: "UnknownCategory") { result in
            // Assert
            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, 0, "Expected no products for an unknown category")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
