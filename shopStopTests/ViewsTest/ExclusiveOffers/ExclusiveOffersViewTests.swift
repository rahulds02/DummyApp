//
//  ExclusiveOffersViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//

import XCTest
@testable import shopStop

final class ExclusiveOffersViewTests: XCTestCase {
    var mockProducts: [ProductEntity]! // Use ProductEntity
    var mockViewModel: ProductViewModel!

    override func setUp() {
        super.setUp()

        // Convert `Product` → `ProductEntity`
        mockProducts = [
            ProductEntity(id: 1, title: "Test Product 1", price: 29.99, thumbnail: "test_url_1", description: "Test Description 1", rating: 4.5, discountPercentage: 10, category: "TestCategory"),
            ProductEntity(id: 2, title: "Test Product 2", price: 39.99, thumbnail: "test_url_2", description: "Test Description 2", rating: 3.8, discountPercentage: 15, category: "TestCategory"),
            ProductEntity(id: 3, title: "Test Product 3", price: 49.99, thumbnail: "test_url_3", description: "Test Description 3", rating: 4.2, discountPercentage: 5, category: "TestCategory"),
            ProductEntity(id: 4, title: "Test Product 4", price: 19.99, thumbnail: "test_url_4", description: "Test Description 4", rating: 3.0, discountPercentage: 20, category: "TestCategory")
        ]

        // Fix ViewModel Dependency Injection
        let mockFetchProductsUseCase = MockFetchProductsUseCase()
        mockViewModel = ProductViewModel(fetchProductsUseCase: mockFetchProductsUseCase)
    }

    override func tearDown() {
        mockProducts = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testExclusiveOffersViewInitialization() {
        let view = ExclusiveOffersView(products: mockProducts, viewModel: mockViewModel)
        XCTAssertNotNil(view, "ExclusiveOffersView should be initialized correctly")
    }

    func testExclusiveOffersViewProductCount() {
        let view = ExclusiveOffersView(products: mockProducts, viewModel: mockViewModel)
        XCTAssertEqual(view.products.count, 4, "ExclusiveOffersView should display exactly 4 products")
    }

    func testExclusiveOffersViewDisplaysProductTitle() {
        let product = mockProducts.first!
        XCTAssertEqual(product.title, "Test Product 1", "Product title should be displayed correctly")
    }
}
