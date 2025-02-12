//
//  MockProductCache.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//

@testable import shopStop
import Foundation
import UIKit

class MockProductCache: ProductCacheProtocol {
    private var cachedProducts: [String: ProductEntity] = [:] // Use `ProductEntity`

    func getProduct(forKey key: String) -> ProductEntity? { // Return `ProductEntity`
        return cachedProducts[key]
    }

    func setProduct(_ product: ProductEntity, forKey key: String) { // Accept `ProductEntity`
        cachedProducts[key] = product
    }

    func setProducts(_ products: [ProductEntity]) { // Accept `[ProductEntity]`
        for product in products {
            setProduct(product, forKey: "\(product.id)")
        }
    }

    func cacheThumbnail(_ image: UIImage, forProductID id: String) { }

    func getAllProducts() -> [ProductEntity] {
        return Array(cachedProducts.values)
    }

    func getProducts(forCategory categoryID: String) -> [ProductEntity] {
        return cachedProducts.values.filter { $0.category == categoryID }
    }

    func clearCache() {
        cachedProducts.removeAll()
    }
}

