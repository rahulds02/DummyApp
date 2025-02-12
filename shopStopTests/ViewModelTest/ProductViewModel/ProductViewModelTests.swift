//
//  ProductViewModelTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//


import XCTest
@testable import shopStop

class ProductViewModelTests: XCTestCase {
    var mockFetchProductsUseCase: MockFetchProductsUseCase!
    var productViewModel: ProductViewModel!

    override func setUp() {
        super.setUp()
        mockFetchProductsUseCase = MockFetchProductsUseCase()
        productViewModel = ProductViewModel(fetchProductsUseCase: mockFetchProductsUseCase)
    }

    override func tearDown() {
        mockFetchProductsUseCase = nil
        productViewModel = nil
        super.tearDown()
    }

    func testDownloadAndCacheImageSuccess() {
        // Arrange
        mockFetchProductsUseCase.downloadAndCacheResult = .success(())

        // Act
        let expectation = XCTestExpectation(description: "Image downloaded and cached successfully")
        productViewModel.downloadAndCacheImage(for: 1) { result in
            // Assert
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
        mockFetchProductsUseCase.downloadAndCacheResult = .failure(mockError)

        // Act
        let expectation = XCTestExpectation(description: "Image download failed")
        productViewModel.downloadAndCacheImage(for: 1) { result in
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

    func testExecuteProductsSuccess() {
        // Arrange
        let mockProducts = [
            Product(id: 1, title: "Product 1", price: 10.0, thumbnail: "url1", description: "Desc", rating: 4.0, discountPercentage: 0.0, category: "Category1"),
            Product(id: 2, title: "Product 2", price: 20.0, thumbnail: "url2", description: "Desc", rating: 4.0, discountPercentage: 0.0, category: "Category1")
        ]
        mockFetchProductsUseCase.executeResult = .success(mockProducts)

        // Act
        let expectation = XCTestExpectation(description: "Fetch products successfully")
        productViewModel.executes(categoryID: "Category1") { result in
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

    func testExecuteProductsFailure() {
        // Arrange
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockFetchProductsUseCase.executeResult = .failure(mockError)

        // Act
        let expectation = XCTestExpectation(description: "Fetch products failed")
        productViewModel.executes(categoryID: "Category1") { result in
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
    
    func testFetchProducts_UsesCachedProducts() {
        let cachedProducts = [
            ProductEntity(id: 1, title: "Cached Product", price: 199.99, thumbnail: "url", description: "Cached Desc", rating: 4.5, discountPercentage: 5.0, category: "electronics")
        ]
        ProductCache.shared.setProducts(cachedProducts)

        productViewModel.fetchProducts(categoryID: "electronics")

       // XCTAssertEqual(productViewModel.products.count, 1, "Should load cached products")
        XCTAssertEqual(productViewModel.products.first?.title, "Cached Product", "Should match cached product title")
    }

   /* func testFetchProducts_CallsAPI_WhenNoCache() {
        let expectation = XCTestExpectation(description: "API call happens")

        ProductCache.shared.setProducts([])
        let mockProducts = [
            Product(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics")
        ]
        mockFetchProductsUseCase.executeResult = .success(mockProducts)

        productViewModel.fetchProducts(categoryID: "electronics")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.productViewModel.products.isEmpty, "Products should be loaded from API")
            XCTAssertEqual(self.productViewModel.products.count, 1, "Products array should contain API fetched products")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }*/

    func testFetchProducts_Failure_ShowsError() {
        let expectation = XCTestExpectation(description: "Error message should be set")

        let mockError = NSError(domain: "APIError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server Error"])
        mockFetchProductsUseCase.executeResult = .failure(mockError)

        productViewModel.fetchProducts(categoryID: "electronics")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.productViewModel.errorMessage, "Error message should be set")
            XCTAssertEqual(self.productViewModel.errorMessage, "Server Error", "Error message should match API failure")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

  /*  func testFetchProducts_LimitsTo10Results() {
        let expectation = XCTestExpectation(description: "API call returns only 10 results")

        // Ensure mockProducts has more than 10 items
        let mockProducts = (1...20).map { id in
            Product(id: id, title: "Product \(id)", price: 100.0, thumbnail: "", description: "Desc", rating: 4.0, discountPercentage: 5.0, category: "electronics")
        }

        // Set the mock response BEFORE calling fetchProducts
        mockFetchProductsUseCase.executeResult = .success(mockProducts)

        // Call the method
        productViewModel.fetchProducts(categoryID: "electronics")

        // Ensure isLoading is set before API completes
        XCTAssertTrue(productViewModel.isLoading, "isLoading should be true while fetching")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Ensure fetchProducts actually populated the list
            XCTAssertFalse(self.productViewModel.products.isEmpty, "Products should be populated")

            // Verify that it only contains the first 10 items
            XCTAssertEqual(self.productViewModel.products.count, 10, "Only first 10 products should be returned")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }*/
}
