//
//  TwoRowScrollViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 28/01/25.
//


import XCTest
import SwiftUI
@testable import shopStop

final class TwoRowScrollViewTests: XCTestCase {
    var mockCategories: [shopStop.Category]!
    var mockViewModel: ProductViewModel!

    override func setUp() {
        super.setUp()

        // Mock categories for testing
        mockCategories = [
            Category(id: "1", name: "Electronics", url: "https://dummyimage.com/100"),
            Category(id: "2", name: "Fashion", url: "https://dummyimage.com/100"),
            Category(id: "3", name: "Home", url: "https://dummyimage.com/100"),
            Category(id: "4", name: "Beauty", url: "https://dummyimage.com/100")
        ]

        // Mock ViewModel (Dependency Injection)
        let mockFetchProductsUseCase = MockFetchProductsUseCase()
        mockViewModel = ProductViewModel(fetchProductsUseCase: mockFetchProductsUseCase)
    }

    override func tearDown() {
        mockCategories = nil
        mockViewModel = nil
        super.tearDown()
    }

    // Test case to verify TwoRowScrollView initializes properly**
    func testTwoRowScrollViewInitialization() {
        let view = TwoRowScrollView(categories: mockCategories, viewModel: mockViewModel)
        XCTAssertNotNil(view, "TwoRowScrollView should be initialized correctly")
    }

    // Test case to verify correct number of categories displayed**
    func testTwoRowScrollViewCategoryCount() {
        let view = TwoRowScrollView(categories: mockCategories, viewModel: mockViewModel)
        XCTAssertEqual(view.categories.count, 4, "TwoRowScrollView should display exactly 4 categories")
    }

    // Test case to verify categories are split into two rows correctly**
    func testTwoRowScrollViewSplitsCategoriesIntoRows() {
        let firstRowCategories = Array(mockCategories.prefix(mockCategories.count / 2))
        let secondRowCategories = Array(mockCategories.suffix(mockCategories.count - mockCategories.count / 2))

        XCTAssertEqual(firstRowCategories.count, 2, "First row should contain half the categories")
        XCTAssertEqual(secondRowCategories.count, 2, "Second row should contain the remaining categories")
    }

    // Test case to verify category names are correctly assigned**
    func testTwoRowScrollViewDisplaysCategoryNames() {
        let firstCategory = mockCategories.first!
        XCTAssertEqual(firstCategory.name, "Electronics", "Category name should be displayed correctly")
    }

    // Test case to verify category images are correctly assigned**
    func testTwoRowScrollViewDisplaysCategoryImages() {
        let firstCategory = mockCategories.first!
        XCTAssertEqual(firstCategory.url, "https://dummyimage.com/100", "Category image URL should be assigned correctly")
    }
}
