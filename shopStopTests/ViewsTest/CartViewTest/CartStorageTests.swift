//
//  CartStorageTests.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 04/02/25.
//


import XCTest
@testable import shopStop

class CartStorageTests: XCTestCase {
    var cartStorage: CartStorage!

    override func setUp() {
        super.setUp()
        cartStorage = CartStorage.shared
        
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "CartProductIDs")
    }

    override func tearDown() {
        cartStorage = nil
        super.tearDown()
    }

    // Test: Add Product to Cart
    func testAddToCart() {
        // Given: A product ID
        let productID = 101

        // When: Adding the product to the cart
        cartStorage.addToCart(productID: productID)

        // Then: The cart should contain the product ID
        let cartItems = cartStorage.getCartProductIDs()
        XCTAssertTrue(cartItems.contains(productID), "Cart should contain the added product ID")
    }

    // Test: Remove Product from Cart**
    func testRemoveFromCart() {
        // Given: Add a product first
        let productID = 202
        cartStorage.addToCart(productID: productID)

        // When: Removing the product from the cart
        cartStorage.removeFromCart(productID: productID)

        // Then: The product should not be in the cart anymore
        let cartItems = cartStorage.getCartProductIDs()
        XCTAssertFalse(cartItems.contains(productID), "Cart should not contain the removed product ID")
    }

    // Test: Get Empty Cart Initially**
    func testGetCartProductIDs_InitiallyEmpty() {
        // Given: UserDefaults is cleared in `setUp()`
        
        // When: Fetching the cart items
        let cartItems = cartStorage.getCartProductIDs()

        // Then: The cart should be empty
        XCTAssertEqual(cartItems.count, 0, "Cart should be empty initially")
    }

    // Test: Prevent Duplicate Entries
    func testPreventDuplicateEntries() {
        // Given: A product ID added twice
        let productID = 303
        cartStorage.addToCart(productID: productID)
        cartStorage.addToCart(productID: productID) // Adding again

        // When: Fetching cart items
        let cartItems = cartStorage.getCartProductIDs()

        // Then: The cart should contain the product ID only once
        XCTAssertEqual(cartItems.filter { $0 == productID }.count, 1, "Cart should not contain duplicate entries")
    }

    // Test: Save and Retrieve Cart Persistently**
    func testCartPersistence() {
        // Given: A list of product IDs
        let productIDs = [401, 402, 403]
        productIDs.forEach { cartStorage.addToCart(productID: $0) }

        // When: Fetching cart items from a new instance
        let newCartStorage = CartStorage.shared
        let retrievedItems = newCartStorage.getCartProductIDs()

        // Then: The cart should still contain the same items
        XCTAssertEqual(Set(retrievedItems), Set(productIDs), "Cart should persist saved product IDs")
    }
}
