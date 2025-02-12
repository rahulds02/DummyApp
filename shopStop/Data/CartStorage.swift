//
//  CartStorage.swift
//  shopStop
//
//  Created by Rahul Sharma on 27/01/25.
//


import Foundation

protocol CartStorageProtocol {
    func getCartProductIDs() -> [Int]
    func removeFromCart(productID: Int)
    func addToCart(productID: Int)
}

class CartStorage: CartStorageProtocol {
    static let shared = CartStorage()

    private let cartKey = "CartProductIDs"

    private init() {}

    // Save product IDs to UserDefaults
    func saveCartProductIDs(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: cartKey)
    }

    // Retrieve product IDs from UserDefaults
    func getCartProductIDs() -> [Int] {
        return UserDefaults.standard.array(forKey: cartKey) as? [Int] ?? []
    }

    // Add a product ID to the cart
    func addToCart(productID: Int) {
        var productIDs = getCartProductIDs()
        if !productIDs.contains(productID) {
            productIDs.append(productID)
        }
        saveCartProductIDs(productIDs)
    }

    // Remove a product ID from the cart
    func removeFromCart(productID: Int) {
        var productIDs = getCartProductIDs()
        productIDs.removeAll { $0 == productID }
        saveCartProductIDs(productIDs)
    }
}
