//
//  AppConstants.swift
//  shopStop
//
//  Created by Rahul Dutt Sharma on 04/02/25.
//

import Foundation

// Centralized Constants File
struct AppConstants {

    // MARK: - API Related Constants
    struct API {
        static let baseURL = "https://dummyjson.com"

        // Endpoints
        static let categories = "/products/categories"
        static let products = "/products/category/"
        static let productDetails = "/products/"
    }

    // MARK: - UI Strings
    struct UI {
        static let appTitle = "ShopStop"

        // Home Screen
        static let homeCategoriesTitle = "Categories"
        static let homePopularPicksTitle = "Popular Picks"
        static let homeExclusiveOffersTitle = "Exclusive Offers"
        static let homeLoadingMessage = "Fetching products..."

        // Product Details
        static let productDetailsTitle = "Product Details"
        static let productNotFound = "Product not found"
        static let addToCart = "Add to Cart"
        static let addedToCart = "Added to Cart"
        static let priceLabel = "Price: $"
        static let ratingLabel = "Rating: "

        // Error Messages
        static let genericErrorMessage = "Something went wrong. Please try again."
        static let home = "Home"
        static let cart = "Cart"
        static let emptyCart = "Your cart is empty."
        static let ok = "OK"
        static let error = "Error"
    }

    // MARK: - Error Messages
    struct Errors {
        static let noInternetConnection = "No internet connection. Please check your connection and try again."
        static let requestFailed = "The request failed. Please try again."
        static let decodingError = "Failed to decode the response. Please try again later."
        static let unknownError = "An unknown error occurred. Please try again."
    }
}
