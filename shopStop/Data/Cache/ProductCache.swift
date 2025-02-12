//
//  ProductCache.swift
//  ShopStop
//
//  Created by Rahul Sharma on 23/01/25.
//

import Foundation
import SwiftUI

protocol ProductCacheProtocol {
    func getProduct(forKey key: String) -> ProductEntity? // Return `ProductEntity`
    func setProduct(_ product: ProductEntity, forKey key: String) // Accept `ProductEntity`
    func setProducts(_ products: [ProductEntity]) // Accept [ProductEntity]`
    func cacheThumbnail(_ image: UIImage, forProductID id: String)
    func getAllProducts() -> [ProductEntity] // Return `[ProductEntity]`
    func getProducts(forCategory categoryID: String) -> [ProductEntity] // Return `[ProductEntity]`
    func clearCache()
}

class ProductCache: ProductCacheProtocol {
    static let shared = ProductCache() // Singleton instance
    private var cache = NSCache<NSString, CachedProduct>() // Cache for product metadata
    private var keys: [NSString] = [] // List to track all keys

    private init() {}

    // Retrieve a single product by key Returns `ProductEntity
    func getProduct(forKey key: String) -> ProductEntity? {
        guard let cachedProduct = cache.object(forKey: key as NSString) else { return nil }
        return cachedProduct.toEntity() // Convert `CachedProduct` → `ProductEntity`
    }

    // Cache a single product Accepts `ProductEntity`
    func setProduct(_ product: ProductEntity, forKey key: String) {
        let nsKey = key as NSString
        if !keys.contains(nsKey) {
            keys.append(nsKey) // Track stored keys
        }
        let cachedProduct = CachedProduct(from: product) // Convert `ProductEntity` → `CachedProduct`
        cache.setObject(cachedProduct, forKey: nsKey)
    }

    // Cache multiple products Accepts `[ProductEntity`
    func setProducts(_ products: [ProductEntity]) {
        for product in products {
            setProduct(product, forKey: "\(product.id)")
        }
    }

    // Cache an image for a product thumbnail
    func cacheThumbnail(_ image: UIImage, forProductID id: String) {
        if let cachedProduct = cache.object(forKey: id as NSString) {
            cachedProduct.thumbnailImage = image // Store the image inside `CachedProduct`
        }
    }

    // Retrieve all cached products (Returns `[ProductEntity]`)
    func getAllProducts() -> [ProductEntity] {
        return keys.compactMap { cache.object(forKey: $0)?.toEntity() }
    }

    // Retrieve cached products for a specific category (Returns `[ProductEntity]`)
    func getProducts(forCategory categoryID: String) -> [ProductEntity] {
        return getAllProducts()
                .filter { $0.category == categoryID }
                .map { cachedProduct in
                    ProductEntity(
                        id: cachedProduct.id,
                        title: cachedProduct.title,
                        price: cachedProduct.price,
                        thumbnail: cachedProduct.thumbnail,
                        description: cachedProduct.description,
                        rating: cachedProduct.rating,
                        discountPercentage: cachedProduct.discountPercentage,
                        category: cachedProduct.category
                    )
                }
    }

    func getCachedProduct(forKey key: String) -> CachedProduct? {
        return cache.object(forKey: key as NSString)
    }

    // Clear the cache
    func clearCache() {
        cache.removeAllObjects()
        keys.removeAll()
    }
}



// Cached Product for NSCache (Not Used in Domain Logic)**
class CachedProduct: NSObject {
    let id: Int
    let title: String
    let price: Double
    let thumbnailURL: String
    var thumbnailImage: UIImage? // Cached thumbnail
    let descriptions: String
    let rating: Double
    let discountPercentage: Double
    let category: String

    /// **Convert `ProductEntity` → `CachedProduct`**
    init(from product: ProductEntity) {
        self.id = product.id
        self.title = product.title
        self.price = product.price
        self.thumbnailURL = product.thumbnail
        self.descriptions = product.description
        self.rating = product.rating
        self.discountPercentage = product.discountPercentage
        self.category = product.category
    }

    /// **Convert `CachedProduct` Back to `ProductEntity`**
    func toEntity() -> ProductEntity {
        return ProductEntity(
            id: id,
            title: title,
            price: price,
            thumbnail: thumbnailURL,
            description: descriptions,
            rating: rating,
            discountPercentage: discountPercentage,
            category: category
        )
    }
}
