//
//  CategoryEntity.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 05/02/25.
//

struct CategoryEntity {
    let id: String // "slug" as the unique identifier
    let name: String
    var imageUrl: String // Placeholder for the category image (can be empty)
}

struct ProductCategoryEntity {
    let products: [Product]
}
