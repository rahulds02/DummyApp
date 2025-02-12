//
//  ProductDTO.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 05/02/25.
//

import Foundation

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let price: Double
    let thumbnail: String
    let description: String
    let rating: Double
    let discountPercentage: Double
    let category: String
}
