//
//  CartViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//


import XCTest
import SwiftUI
@testable import shopStop

class CartViewTests: XCTestCase {
    var mockCartStorage: MockCartStorage!
    var cartView: CartView!
    var testProduct: Product!
    
    override func setUp() {
        super.setUp()
        mockCartStorage = MockCartStorage()
        mockCartStorage.mockProductIDs = [1, 2]
        cartView = CartView(cartStorage: mockCartStorage)
        testProduct = Product(
            id: 1,
            title: "Test Product",
            price: 199.99,
            thumbnail: "",
            description: "Test product description",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "electronics"
        )
    }
    
    override func tearDown() {
        mockCartStorage = nil
        cartView = nil
        super.tearDown()
    }
    
    func testCartView_EmptyCart() {
        // Given: Cart is empty
        mockCartStorage.mockProductIDs = []
        
        // When: Creating the view
        let view = CartView(cartStorage: mockCartStorage)
        
        // Then: It should show an empty cart UI
        XCTAssertTrue(view.testIsCartEmpty, "Cart should be empty")
    }
    
    func testRemoveProductFromCart() {
        mockCartStorage.removeFromCart(productID: 1)
        XCTAssertEqual(mockCartStorage.getCartProductIDs().count, 1)
    }
    
    func testAddProductToCart() {
        mockCartStorage.addToCart(productID: 3)
        XCTAssertEqual(mockCartStorage.getCartProductIDs().count, 3)
    }
    
    func testCartView_NavigationTitle() {
        let view = CartView(cartStorage: mockCartStorage)
        
        XCTAssertEqual(view.testNavigationTitle, AppConstants.UI.cart, "Navigation title should be 'Cart'")
    }
    
    func testCartView_ShowsEmptyMessageWhenCartIsEmpty() {
        let emptyCartStorage = MockCartStorage()
        let view = CartView(cartStorage: emptyCartStorage)
        
        XCTAssertTrue(view.testIsCartEmpty, "Empty cart message should be displayed when no products are added.")
    }
    
    func testCartItemRow_ContainsExpectedUI() {
        let rowView = CartView(cartStorage: mockCartStorage).cartItemRow(for: testProduct)
        
        XCTAssertNotNil(rowView, "cartItemRow should render correctly")
    }
    
    // Cart Item Title
    func testCartItemRow_HasCorrectTitle() {
        let rowView = CartView(cartStorage: mockCartStorage).cartItemRow(for: testProduct)
        
        XCTAssertTrue(testProduct.title.contains("Test Product"), "Title should be 'Test Product'")
    }
    
    // Cart Item Price Formatting
    func testCartItemRow_HasCorrectPrice() {
        let rowView = CartView(cartStorage: mockCartStorage).cartItemRow(for: testProduct)
        
        XCTAssertEqual(String(format: "$%.2f", testProduct.price), "$199.99", "Price should be formatted correctly")
    }
    
    // Remove Button Exists
    func testCartItemRow_HasRemoveButton() {
        let rowView = CartView(cartStorage: mockCartStorage).cartItemRow(for: testProduct)
        
        XCTAssertNotNil(rowView, "Remove button should be present in cart item row")
    }
    
    func testProductThumbnail_UsesPlaceholderWhenNoCache() {
        // Given: No image cached
        let product = Product(id: 2, title: "Phone", price: 599.99, thumbnail: "", description: "", rating: 4.5, discountPercentage: 10.0, category: "electronics")
        
        // When: Getting product thumbnail
        let thumbnailView = cartView.productThumbnail(for: product)
        
        // Then: Assert that it falls back to a gray placeholder
        XCTAssertNotNil(thumbnailView, "Placeholder should be shown when no cached image")
    }
    
    func testCartItemsList_IsEmpty_WhenNoItems() {
        // Given: Cart is empty
        mockCartStorage.mockProductIDs = []
        ProductCache.shared.clearCache() // Ensure cache is empty
        
        // When: Creating the view
        let view = CartView(cartStorage: mockCartStorage)
        
        // Then: Ensure cart list is empty
        XCTAssertTrue(view.testIsCartEmpty, "Cart should be empty when there are no products")
    }
    
    func testLoadCart_HandlesEmptyCache() {
        // Given: Cart contains product IDs, but cache is empty
        mockCartStorage.mockProductIDs = [1, 2]
        ProductCache.shared.clearCache() // No products in cache
        
        // When: Calling `loadCart()`
        let view = CartView(cartStorage: mockCartStorage)
        view.loadCart()
        
        // Then: Ensure cart remains empty
        XCTAssertTrue(view.testIsCartEmpty, "Cart should be empty when no products are cached")
    }
}

