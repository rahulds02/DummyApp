//
//  CategoryDTO.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 05/02/25.
//

struct CategoryDTO: Codable, Identifiable {
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

struct ProductCategoryDTO: Codable {
    let products: [ProductDTO]
}
