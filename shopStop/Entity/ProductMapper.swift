//
//  ProductMapper.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 05/02/25.
//

import Foundation

class ProductMapper {
    /// **Convert `ProductDTO` → `ProductEntity` (For Data Layer)**
    static func mapDTOToEntity(_ dtos: [ProductDTO]) -> [ProductEntity] {
        return dtos.map { dto in
            ProductEntity(
                id: dto.id,
                title: dto.title,
                price: dto.price,
                thumbnail: dto.thumbnail, // thumbnail` is used instead of `thumbnailURL`
                description: dto.description,
                rating: dto.rating,
                discountPercentage: dto.discountPercentage,
                category: dto.category
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
    
    /// **Convert `ProductEntity` → `Product` (For Domain Layer)**
    static func mapEntityToDomain(_ entities: [ProductEntity]) -> [Product] {
        return entities.map { entity in
            Product(
                id: entity.id,
                title: entity.title,
                price: entity.price,
                thumbnail: entity.thumbnail,
                description: entity.description,
                rating: entity.rating,
                discountPercentage: entity.discountPercentage,
                category: entity.category
            )
        }
    }

    static func mapDomainToEntity(_ products: [Product]) -> [ProductEntity] {
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

    static func mapDomainToDTO(_ products: [Product]) -> [ProductDTO] {
        return products.map { product in
            ProductDTO(
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
