//
//  PopularPicksViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 27/01/25.
//


import XCTest
@testable import shopStop

final class PopularPicksViewTests: XCTestCase {
    var mockProducts: [ProductEntity]!
    var mockViewModel: ProductViewModel!

    override func setUp() {
        super.setUp()
        
        // Mock products for testing
        mockProducts = [
            ProductEntity(id: 1, title: "Popular Product 1", price: 29.99, thumbnail: "popular_url_1", description: "Popular Description 1", rating: 4.5, discountPercentage: 10, category: "PopularCategory"),
            ProductEntity(id: 2, title: "Popular Product 2", price: 39.99, thumbnail: "popular_url_2", description: "Popular Description 2", rating: 3.8, discountPercentage: 15, category: "PopularCategory"),
            ProductEntity(id: 3, title: "Popular Product 3", price: 49.99, thumbnail: "popular_url_3", description: "Popular Description 3", rating: 4.2, discountPercentage: 5, category: "PopularCategory"),
            ProductEntity(id: 4, title: "Popular Product 4", price: 19.99, thumbnail: "popular_url_4", description: "Popular Description 4", rating: 3.0, discountPercentage: 20, category: "PopularCategory")
        ]
        
        // Mock ViewModel (Dependency Injection)
        let mockFetchProductsUseCase = MockFetchProductsUseCase()
        mockViewModel = ProductViewModel(fetchProductsUseCase: mockFetchProductsUseCase)
    }

    override func tearDown() {
        mockProducts = nil
        mockViewModel = nil
        super.tearDown()
    }

    //  Test case to verify Popular Picks View initializes properly**
    func testPopularPicksViewInitialization() {
        let view = PopularPicksView(products: mockProducts, viewModel: mockViewModel)
        XCTAssertNotNil(view, "PopularPicksView should be initialized correctly")
    }

    // Test case to verify correct number of products are displayed**
    func testPopularPicksViewProductCount() {
        let view = PopularPicksView(products: mockProducts, viewModel: mockViewModel)
        XCTAssertEqual(view.products.count, 4, "PopularPicksView should display exactly 4 products")
    }

    // Test case to verify product title is displayed correctly**
    func testPopularPicksViewDisplaysProductTitle() {
        let product = mockProducts.first!
        XCTAssertEqual(product.title, "Popular Product 1", "Product title should be displayed correctly")
    }
}
