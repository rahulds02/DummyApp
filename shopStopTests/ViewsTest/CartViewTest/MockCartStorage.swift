//
//  MockCartStorage.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//
import XCTest
import SwiftUI
@testable import shopStop

class MockCartStorage: CartStorageProtocol {
    var mockProductIDs: [Int] = []

    func getCartProductIDs() -> [Int] {
        return mockProductIDs
    }

    func removeFromCart(productID: Int) {
        mockProductIDs.removeAll { $0 == productID }
    }

    func addToCart(productID: Int) {
        mockProductIDs.append(productID)
    }
}
