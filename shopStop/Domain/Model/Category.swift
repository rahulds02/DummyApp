//
//  Categorr.swift
//  ShopStop
//
//  Created by Rahul Sharma on 22/01/25.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let thumbnail: String
    let description: String
    let rating: Double
    let discountPercentage: Double
    let category: String
}

struct Category: Codable, Identifiable {
    let id: String // "slug" as the unique identifier
    let name: String
    var url: String // Placeholder for the category image (can be empty)
    //var products: [Product]? // Optional: Products for the category, fetched later

    // Map "slug" to "id"
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
}

struct ProductCategory: Codable {
    let products: [Product]
}
