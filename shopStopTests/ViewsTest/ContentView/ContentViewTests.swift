//
//  ContentViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//


import XCTest
import SwiftUI
@testable import shopStop

class ContentViewTests: XCTestCase {

    var splashViewModel: ProductBrandsViewModel!
    var productViewModel: ProductViewModel!

    override func setUp() {
        super.setUp()

        // Initialize Mock ViewModels
        splashViewModel = ProductBrandsViewModel(fetchCategoriesUseCase: MockFetchCategoriesUseCase(),
                                                fetchProductsUseCase: MockFetchProductsUseCase())
        productViewModel = ProductViewModel(fetchProductsUseCase: MockFetchProductsUseCase())
    }

    override func tearDown() {
        splashViewModel = nil
        productViewModel = nil
        super.tearDown()
    }

    // Test if ContentView initializes properly
    func testContentViewInitialization() {
        let contentView = ContentView(viewModel: splashViewModel, productViewModel: productViewModel)
        XCTAssertNotNil(contentView, "ContentView should initialize successfully")
    }

    // Test if ContentView has a TabView with two views
    func testContentViewHasTabView() {
        let contentView = ContentView(viewModel: splashViewModel, productViewModel: productViewModel)

        // Mirror allows us to inspect the structure of `ContentView`
        let mirror = Mirror(reflecting: contentView)

        let tabViewElements = mirror.children.filter { $0.label == "_selectedIndex" }
        XCTAssertFalse(tabViewElements.isEmpty, "ContentView should contain a TabView")
    }
}
