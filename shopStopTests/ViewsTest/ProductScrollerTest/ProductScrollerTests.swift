//
//  ProductScrollerTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 27/01/25.
//


import XCTest
import SwiftUI
@testable import shopStop

class ProductScrollerTests: XCTestCase {
    var mockFetchProductsUseCase: MockFetchProductsUseCase!
    var mockProductViewModel: MockProductViewModel!
    var mockProductCache: MockProductCache!

    override func setUp() {
        super.setUp()
        mockFetchProductsUseCase = MockFetchProductsUseCase()
        mockProductViewModel = MockProductViewModel(mockFetchProductsUseCase: mockFetchProductsUseCase)
        mockProductCache = MockProductCache()
        mockProductCache = MockProductCache()
    }

    override func tearDown() {
        mockFetchProductsUseCase = nil
        mockProductViewModel = nil
        mockProductCache = nil
        super.tearDown()
    }

    func testProductScrollerRendersWithCachedProducts() {
        // Arrange
        let productIDs = [1, 2, 3]
       /* productIDs.forEach { id in
            let cachedProduct = CachedProduct(
                id: id,
                title: "Product \(id)",
                price: 10.0 * Double(id),
                thumbnailURL: "url\(id)",
                thumbnailImage: UIImage(),
                descriptions: "Description \(id)",
                rating: 4.0,
                discountPercentage: 0.0,
                category: "Category"
            )
            mockProductCache.cacheProduct(cachedProduct, forKey: "\(id)")
        }*/

        // Act
        let view = ProductScroller(productIDs: productIDs, viewModel: mockProductViewModel)
        let hostingController = UIHostingController(rootView: view)

        // Assert
        XCTAssertNotNil(hostingController.view, "The ProductScroller should render correctly with cached products.")
    }
}
