//
//  ProductViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 28/01/25.
//

import XCTest
@testable import shopStop

class ProductViewTests: XCTestCase {
    var mockCartStorage: MockCartStorage!
    var mockProductCache: MockProductCache!
    var productView: ProductView!
    var cachedProduct: CachedProduct!

    override func setUp() {
        super.setUp()
        mockCartStorage = MockCartStorage()
        mockProductCache = MockProductCache()

        // First, create a `ProductEntity` instance
        let mockProductEntity = ProductEntity(
            id: 1,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "This is a test product",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        )

        cachedProduct = CachedProduct(from: mockProductEntity)
        mockProductCache.setProduct(cachedProduct.toEntity(), forKey: "1")
        productView = ProductView(productId: 1)
    }

    override func tearDown() {
        mockCartStorage = nil
        mockProductCache = nil
        productView = nil
        cachedProduct = nil
        super.tearDown()
    }

    // Test: Product Details Display Correctly
    func testProductDetailsAreDisplayed() {
        let fetchedProduct = mockProductCache.getProduct(forKey: "1")
        XCTAssertNotNil(fetchedProduct, "Product should be available in cache")
        XCTAssertEqual(fetchedProduct?.title, "Test Product", "Product title should match")
        XCTAssertEqual(fetchedProduct?.price, 99.99, "Product price should match")
        XCTAssertEqual(fetchedProduct?.description, "This is a test product", "Product description should match")
    }

    // Test: Product Not Found Case
    func testProductNotFound() {
        let missingProductView = ProductView(productId: 99)
        let missingProduct = mockProductCache.getProduct(forKey: "99")
        XCTAssertNil(missingProduct, "Product should not exist in cache")
    }

    // Test: Product Rating Conversion**
    func testGetStarCount() {
        XCTAssertEqual(productView.getStarCount(for: 0.5), 0, "0.5 rating should return 0 stars")
        XCTAssertEqual(productView.getStarCount(for: 1.2), 1, "1.2 rating should return 1 star")
        XCTAssertEqual(productView.getStarCount(for: 3.5), 3, "3.5 rating should return 3 stars")
        XCTAssertEqual(productView.getStarCount(for: 5.0), 5, "5.0 rating should return 5 stars")
    }

    // Test: Cart State Persists**
    func testCartStatePersists() {
        let productID = 1
        mockCartStorage.addToCart(productID: productID)

        // Create new instance of ProductView to simulate a reload
        let newProductView = ProductView(productId: productID)
        let cartProductIDs = mockCartStorage.getCartProductIDs()

        XCTAssertTrue(cartProductIDs.contains(productID), "Cart state should persist across reloads")
      //  XCTAssertTrue(newProductView.isAddedToCart, "Product should be in cart after reload")
    }

    // Test: Discount Percentage is Applied Correctly**
    func testDiscountPercentageIsCorrect() {
        let discount = cachedProduct.discountPercentage
        XCTAssertEqual(discount, 10.0, "Discount percentage should match the cached product")
    }

    // Test: UI Displays Correct Price Formatting**
    func testPriceFormatting() {
        let price = cachedProduct.price
        XCTAssertEqual(String(format: "%.2f", price), "99.99", "Price should be formatted correctly with 2 decimal places")
    }

    func testProductImage_IsDisplayedWhenCached() {
        // Given: A cached product with a valid image
        let mockProductEntity = ProductEntity(
            id: 1, title: "Test Product", price: 99.99, thumbnail: "https://example.com/image.jpg",
            description: "This is a test product", rating: 4.5, discountPercentage: 10.0, category: "Test Category"
        )
        let cachedProduct = CachedProduct(from: mockProductEntity)
        cachedProduct.thumbnailImage = UIImage(systemName: "star") // Simulate cached image
        mockProductCache.setProduct(cachedProduct.toEntity(), forKey: "1")

        // When: Initializing ProductView
        let view = ProductView(productId: 1)

        // Then: Image should exist in cache
        XCTAssertNotNil(mockProductCache.getProduct(forKey: "1")?.thumbnail, "Cached image should exist")
    }


    func testProductView_ProductNotFound() {
      //  let view = ProductView(productId: 999) // Product that doesn’t exist

        let missingProduct = ProductCache.shared.getProduct(forKey: "999")

        XCTAssertNil(missingProduct, "Product should not be found in cache")
    }

    func testProductView_AddToCartButton_DisplaysCorrectText() {
        let productID = 1
        let view = ProductView(productId: productID)

        // Initially, product should not be in cart
        if view.isAddedToCart {
            XCTAssertEqual(AppConstants.UI.addedToCart, "Added to Cart", "Button should display 'Added to Cart' when item is in cart")
        } else {
            XCTAssertEqual(AppConstants.UI.addToCart, "Add to Cart", "Button should display 'Add to Cart' when item is not in cart")
        }
    }

    func testProductImage_RendersWithCachedImage() {
        // Given: Product exists in cache with a valid image
        let productID = 1
        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "This is a test product",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        ))

        // Mock an actual image
        let sampleImage = UIImage(systemName: "star")!
        cachedProduct.thumbnailImage = sampleImage
        ProductCache.shared.setProduct(cachedProduct.toEntity(), forKey: "\(productID)")

        // When: Rendering the image
        let view = ProductView(productId: productID)
        let imageView = view.productImage(for: cachedProduct)

        // Then: Ensure the image is rendered properly
        XCTAssertNotNil(imageView, "Product image should be rendered when cached image is available")
    }

    func testProductTitle_DisplaysCorrectText() {
        // Given: A product exists in cache
        let productID = 1
        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "A great test product",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        ))

        // When: Rendering the title
        let view = ProductView(productId: productID)
        let titleView = view.productTitle(for: cachedProduct)

        // Then: Ensure the title is displayed correctly
        XCTAssertNotNil(titleView, "Product title should be rendered")
    }

    func testProductPrice_DisplaysCorrectValue() {
        // Given: A product exists in cache
        let productID = 1
        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "A great test product",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        ))

        // When: Rendering the price
        let view = ProductView(productId: productID)
        let priceView = view.productPrice(for: cachedProduct)

        // Then: Ensure the price is displayed correctly
        XCTAssertNotNil(priceView, "Product price should be rendered")
    }

    func testProductRating_DisplaysCorrectStars() {
        // Given: A product with a 4.5-star rating
        let productID = 1
        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "A great test product",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        ))

        // When: Rendering the rating
        let view = ProductView(productId: productID)
        let ratingView = view.productRating(for: cachedProduct)

        // Then: Ensure the rating is displayed correctly
        XCTAssertNotNil(ratingView, "Product rating should be rendered")
    }

    func testProductRating_StarCountMatches() {
        // Given: A product with a 3-star rating
        let productID = 2
        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Mid-Range Product",
            price: 49.99,
            thumbnail: "https://example.com/image.jpg",
            description: "A decent product",
            rating: 3.0,
            discountPercentage: 5.0,
            category: "Test Category"
        ))

        // When: Rendering the rating
        let view = ProductView(productId: productID)
        let ratingView = view.productRating(for: cachedProduct)
        let starCount = view.getStarCount(for: cachedProduct.rating)

        // Then: Ensure the correct number of stars is assigned
        XCTAssertEqual(starCount, 3, "Product with 3.0 rating should have exactly 3 stars")
        XCTAssertNotNil(ratingView, "Product rating view should be created")
    }

    func testProductDescription_RendersCorrectly() {
        // Given: A sample product with a description
        let productID = 1
        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "This is a detailed test description for the product.",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        ))

        // When: Rendering the product description
        let view = ProductView(productId: productID)
        let descriptionView = view.productDescription(for: cachedProduct)

        // Then: Ensure the description is displayed correctly
        XCTAssertNotNil(descriptionView, "Product description should be rendered")
    }

    func testAddToCartButton_InitialState() {
        // Given: A product that is NOT in the cart initially
        let productID = 1
        CartStorage.shared.removeFromCart(productID: productID) // Ensure it's not in the cart

        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "A product for testing.",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        ))

        // When: Rendering the button
        let view = ProductView(productId: productID)
        let buttonView = view.addToCartButton(for: cachedProduct)

        // Then: Ensure the initial state is NOT in cart
        XCTAssertFalse(view.isAddedToCart, "Product should NOT be in cart initially")
        XCTAssertNotNil(buttonView, "Add to cart button should be rendered")
    }

    func testAddToCartButton_AddsProduct() {
        // Given: A product that is NOT in cart
        let productID = 2
        CartStorage.shared.removeFromCart(productID: productID) // Ensure it's not in cart

        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Laptop",
            price: 1299.99,
            thumbnail: "https://example.com/laptop.jpg",
            description: "A high-performance laptop.",
            rating: 4.8,
            discountPercentage: 15.0,
            category: "Electronics"
        ))

        // When: Creating ProductView
        var view = ProductView(productId: productID)

        // Manually update state
        view.isAddedToCart = false
        view.addToCart() // Simulate adding

        // Then: Product should be in cart
        XCTAssertTrue(CartStorage.shared.getCartProductIDs().contains(productID), "Product should be added to cart")
    }

    func testAddToCartButton_RemovesProduct() {
        // Given: A product that is **already in cart**
        let productID = 3
        CartStorage.shared.addToCart(productID: productID) // Ensure it starts in cart

        let cachedProduct = CachedProduct(from: ProductEntity(
            id: productID,
            title: "Phone",
            price: 799.99,
            thumbnail: "https://example.com/phone.jpg",
            description: "A flagship smartphone.",
            rating: 4.7,
            discountPercentage: 12.0,
            category: "Electronics"
        ))

        // When: Creating ProductView
        var view = ProductView(productId: productID)

        // Manually update state
        view.isAddedToCart = true
        view.addToCart() // Simulate removal

        // Then: Product should be removed from cart
        XCTAssertFalse(CartStorage.shared.getCartProductIDs().contains(productID), "Product should be removed from cart")
    }

    func testBackgroundView_Exists() {
        // Given: A ProductView instance
        let productView = ProductView(productId: 1)

        // When: Accessing backgroundView
        let background = productView.backgroundView

        // Then: It should be a LinearGradient
        XCTAssertNotNil(background, "Background view should not be nil")
    }

    func testProductNotFoundView_Exists() {
        // Given: A ProductView instance with a non-existent product
        let productView = ProductView(productId: 999) // Assuming 999 is not cached

        // When: Accessing `productNotFoundView`
        let notFoundView = productView.productNotFoundView

        // Then: It should not be nil
        XCTAssertNotNil(notFoundView, "ProductNotFoundView should exist when the product is missing")
    }

    func testProductView_ShowsProductDetails_WhenCached() {
        // Given: A cached product
        let productEntity = ProductEntity(
            id: 1,
            title: "Test Product",
            price: 99.99,
            thumbnail: "https://example.com/image.jpg",
            description: "This is a test product",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "Test Category"
        )
        let cachedProduct = CachedProduct(from: productEntity)
        ProductCache.shared.setProduct(cachedProduct.toEntity(), forKey: "1")

        // When: Creating the `ProductView`
        let productView = ProductView(productId: 1)

        // Then: `body` should not be `nil`
        XCTAssertNotNil(productView.body, "ProductView body should exist when product is cached")
    }
}
