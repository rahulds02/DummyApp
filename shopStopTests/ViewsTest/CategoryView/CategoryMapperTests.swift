//
//  CategoryMapperTests.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 06/02/25.
//


import XCTest
@testable import shopStop

final class CategoryMapperTests: XCTestCase {

    // Test Mapping CategoryDTO → CategoryEntity
    func testMapToEntity() {
        // Given: Mock DTOs
        let dtos = [
            CategoryDTO(id: "electronics", name: "Electronics", url: "https://example.com/electronics.jpg"),
            CategoryDTO(id: "fashion", name: "Fashion", url: "https://example.com/fashion.jpg")
        ]

        // When: Convert to `CategoryEntity`
        let entities = CategoryMapper.mapToEntity(dtos)

        // Then: Verify the mapping
        XCTAssertEqual(entities.count, 2, "Expected 2 mapped category entities")
        XCTAssertEqual(entities[0].id, "electronics")
        XCTAssertEqual(entities[0].name, "Electronics")
        XCTAssertEqual(entities[0].imageUrl, "https://example.com/electronics.jpg")
        XCTAssertEqual(entities[1].id, "fashion")
        XCTAssertEqual(entities[1].name, "Fashion")
        XCTAssertEqual(entities[1].imageUrl, "https://example.com/fashion.jpg")
    }

    // Test Mapping CategoryEntity → Category
    func testMapToDomain() {
        // Given: Mock Entities
        let entities = [
            CategoryEntity(id: "electronics", name: "Electronics", imageUrl: "https://example.com/electronics.jpg"),
            CategoryEntity(id: "fashion", name: "Fashion", imageUrl: "https://example.com/fashion.jpg")
        ]

        // When: Convert to `Category`
        let domainCategories = CategoryMapper.mapToDomain(entities)

        // Then: Verify the mapping
        XCTAssertEqual(domainCategories.count, 2, "Expected 2 mapped domain categories")
        XCTAssertEqual(domainCategories[0].id, "electronics")
        XCTAssertEqual(domainCategories[0].name, "Electronics")
        XCTAssertEqual(domainCategories[0].url, "https://example.com/electronics.jpg")
        XCTAssertEqual(domainCategories[1].id, "fashion")
        XCTAssertEqual(domainCategories[1].name, "Fashion")
        XCTAssertEqual(domainCategories[1].url, "https://example.com/fashion.jpg")
    }

    func testMapProductToEntity() {
        // Given: Mock Products
        let products = [
            Product(id: 1, title: "Laptop", price: 999.99, thumbnail: "laptop.jpg", description: "High-end laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics"),
            Product(id: 2, title: "Smartphone", price: 499.99, thumbnail: "smartphone.jpg", description: "Latest smartphone", rating: 4.0, discountPercentage: 5.0, category: "electronics")
        ]

        // When: Convert to `ProductEntity`
        let productEntities = CategoryMapper.mapProductToEntity(products)

        // Then: Verify the mapping
        XCTAssertEqual(productEntities.count, 2, "Expected 2 mapped product entities")
        XCTAssertEqual(productEntities[0].id, 1)
        XCTAssertEqual(productEntities[0].title, "Laptop")
        XCTAssertEqual(productEntities[0].price, 999.99)
        XCTAssertEqual(productEntities[0].thumbnail, "laptop.jpg")
        XCTAssertEqual(productEntities[0].description, "High-end laptop")
        XCTAssertEqual(productEntities[0].rating, 4.5)
        XCTAssertEqual(productEntities[0].discountPercentage, 10.0)
        XCTAssertEqual(productEntities[0].category, "electronics")
    }
}
