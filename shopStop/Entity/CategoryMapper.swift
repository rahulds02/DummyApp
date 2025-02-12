//
//  CategoryMapper.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 05/02/25.
//

import Foundation

class CategoryMapper {
    // Convert `CategoryDTO` → `CategoryEntity`
    static func mapToEntity(_ dtos: [CategoryDTO]) -> [CategoryEntity] {
        return dtos.map { dto in
            CategoryEntity(
                id: dto.id,
                name: dto.name,
                imageUrl: dto.url // Proper mapping
            )
        }
    }

    // Convert `CategoryEntity` → `Category` (For Domain Layer)
    static func mapToDomain(_ entities: [CategoryEntity]) -> [Category] {
        return entities.map { entity in
            Category(
                id: entity.id,
                name: entity.name,
                url: entity.imageUrl // Ensure proper field mapping
            )
        }
    }

    static func mapProductToEntity(_ products: [Product]) -> [ProductEntity] {
        return products.map { product in
            ProductEntity(
                id: product.id,
                title: product.title,
                price: product.price,
                thumbnail: product.thumbnail,
                description: product.description,
                rating: product.rating,
                discountPercentage: product.discountPercentage,
                category: product.category
            )
        }
    }
}
