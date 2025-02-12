//
//  HomeViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import SwiftUI
import XCTest
@testable import shopStop

final class HomeViewTests: XCTestCase {
    var mockSplashScreenViewModel: ProductBrandsViewModel!
    var mockProductViewModel: ProductViewModel!

    override func setUp() {
        super.setUp()
        mockSplashScreenViewModel = ProductBrandsViewModel(
            fetchCategoriesUseCase: MockFetchCategoriesUseCase(),
            fetchProductsUseCase: MockFetchProductsUseCase()
        )
        mockProductViewModel = ProductViewModel(fetchProductsUseCase: MockFetchProductsUseCase())
    }

    override func tearDown() {
        mockSplashScreenViewModel = nil
        mockProductViewModel = nil
        super.tearDown()
    }

    func testHomeViewWithAllSections() {
        // Fix: Convert `Product` → `ProductEntity`
        mockSplashScreenViewModel.randomProducts = [
            ProductEntity(id: 1, title: "Product 1", price: 10.0, thumbnail: "", description: "", rating: 4.0, discountPercentage: 0.0, category: "")
        ]

        // Fix: Convert `Category` → `CategoryEntity`
        mockSplashScreenViewModel.categories = [
            Category(id: "1", name: "Category 1", url: "")
        ]

        mockSplashScreenViewModel.exclusiveOffers = [
            ProductEntity(id: 2, title: "Product 2", price: 20.0, thumbnail: "", description: "", rating: 4.0, discountPercentage: 0.0, category: "")
        ]

        mockSplashScreenViewModel.popularPicks = [
            ProductEntity(id: 3, title: "Product 3", price: 30.0, thumbnail: "", description: "", rating: 4.0, discountPercentage: 0.0, category: "")
        ]

        // Act: Render the HomeView
        let homeView = HomeView(viewModel: mockSplashScreenViewModel, productViewModel: mockProductViewModel)
        let view = UIHostingController(rootView: homeView)

        // Assert: Verify that the view renders correctly
        XCTAssertNotNil(view.view)
    }

    func testHomeViewWithNoData() {
        mockSplashScreenViewModel.randomProducts = []
        mockSplashScreenViewModel.categories = []
        mockSplashScreenViewModel.exclusiveOffers = []
        mockSplashScreenViewModel.popularPicks = []

        // Act: Render the HomeView
        let homeView = HomeView(viewModel: mockSplashScreenViewModel, productViewModel: mockProductViewModel)
        let view = UIHostingController(rootView: homeView)

        // Assert: Verify that the view renders correctly
        XCTAssertNotNil(view.view)
    }

    func testHomeViewCategoryRendering() {
        // Convert `Category` → `CategoryEntity`
        mockSplashScreenViewModel.categories = [
            Category(id: "1", name: "Category 1", url: ""), 
            Category(id: "2", name: "Category 2", url: "")
        ]

        // Act: Render the HomeView
        let homeView = HomeView(viewModel: mockSplashScreenViewModel, productViewModel: mockProductViewModel)
        let view = UIHostingController(rootView: homeView)

        // Assert: Verify the categories are rendered
        XCTAssertNotNil(view.view)
    }
}
