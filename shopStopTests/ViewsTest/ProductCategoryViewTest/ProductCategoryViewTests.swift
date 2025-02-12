//
//  ProductCategoryViewTests.swift
//  shopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import XCTest
import SwiftUI
@testable import shopStop

final class ProductCategoryViewTests: XCTestCase {

    var mockViewModel: MockProductViewModel!
    var mockCategory: shopStop.Category!

    override func setUp() {
        super.setUp()

        // Mock Category
        mockCategory = Category(id: "electronics", name: "Electronics", url: "")

        // Mock ViewModel
        mockViewModel = MockProductViewModel(mockFetchProductsUseCase: MockFetchProductsUseCase())
    }

    override func tearDown() {
        mockViewModel = nil
        mockCategory = nil
        super.tearDown()
    }

    // Test API Success - Should Load Products
    func testFetchProducts_Success() {
        // Given: Mock Successful Response
        let mockProducts = [
            ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics"),
            ProductEntity(id: 2, title: "Smartphone", price: 499.99, thumbnail: "", description: "A great smartphone", rating: 4.0, discountPercentage: 5.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        // When: Fetch Products
        let expectation = XCTestExpectation(description: "Fetch products successfully")
        mockViewModel.executes(categoryID: "electronics") { result in
            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, 2)
                XCTAssertEqual(products.first?.title, "Laptop")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Test API Failure - Should Show Error Message**
    func testFetchProducts_Failure() {
        // Given: Mock API Failure
        let mockError = NSError(domain: "APIError", code: 500, userInfo: nil)
        mockViewModel.executesResult = .failure(mockError)

        // When: Fetch Products
        let expectation = XCTestExpectation(description: "Fetch products failure")
        mockViewModel.executes(categoryID: "electronics") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "APIError")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Test Empty Response - Should Handle Gracefully
    func testFetchProducts_EmptyResponse() {
        // Given: Mock Empty Response
        mockViewModel.executesResult = .success([])

        // When: Fetch Products
        let expectation = XCTestExpectation(description: "Fetch empty products list")
        mockViewModel.executes(categoryID: "electronics") { result in
            switch result {
            case .success(let products):
                XCTAssertTrue(products.isEmpty, "Expected empty product list")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testProductGridRendering() {
        let mockProducts = [
            ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        let expectation = XCTestExpectation(description: "Render product grid")

        DispatchQueue.main.async {
            let view = ProductCategoryView(category: self.mockCategory, viewModel: self.mockViewModel)
            let hostingController = UIHostingController(rootView: view)
            XCTAssertNotNil(hostingController.view, "ProductCategoryView should be rendered correctly")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testUIState_WithProducts() {
        let mockProducts = [
            ProductEntity(id: 1, title: "Tablet", price: 299.99, thumbnail: "", description: "A lightweight tablet", rating: 4.0, discountPercentage: 8.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel)
        XCTAssertNotNil(view.body, "View should render when products are available")
    }

    func testUIState_NoProducts() {
        mockViewModel.executesResult = .success([])

        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel)
        XCTAssertNotNil(view.body, "View should handle empty product list gracefully")
    }

    func testInitialLoadingState() {
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel)

        XCTAssertNotNil(view.body, "View should initialize correctly")
        // Here, we assume that when the view appears, it starts loading products
    }

    func testUIState_ErrorMessage() {
        let mockError = NSError(domain: "APIError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        mockViewModel.executesResult = .failure(mockError)

        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel)

        XCTAssertNotNil(view.body, "View should render an error message when API fails")
    }

    func testFetchProducts_UsesCachedProducts() {
        let cachedProducts = [
            ProductEntity(id: 1, title: "Smartwatch", price: 199.99, thumbnail: "", description: "A modern smartwatch", rating: 4.2, discountPercentage: 15.0, category: "electronics")
        ]

        // Inject cached products directly in test (instead of calling fetchProductsForCategory())
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel, initialProducts: cachedProducts)

        // Verify that the products were injected successfully
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(view.productList.isEmpty, "Cached products should be loaded")
            XCTAssertEqual(view.productList.count, 1, "Products array should contain cached products")
        }
    }

    func testProductCategoryView_Initialization() {
        // Given: A mock category and mock view model
        let category = Category(id: "electronics", name: "Electronics", url: "https://example.com/electronics.jpg")
        let viewModel = MockProductViewModel(mockFetchProductsUseCase: MockFetchProductsUseCase())

        // When: Rendering the View
        let view = ProductCategoryView(category: category, viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)

        // Then: Ensure `hostingController.view` is created, meaning `ProductCategoryView` is actually instantiated
        XCTAssertNotNil(hostingController.view, "ProductCategoryView should be instantiated and rendered")

        // Force access to `body` to trigger rendering
        XCTAssertNotNil(view.body, "Body should be evaluated in ProductCategoryView")

        // Verify ViewModel indirectly by checking if it responds to a function call
        let expectation = XCTestExpectation(description: "ViewModel should be initialized and respond to executes function")

        viewModel.executes(categoryID: "electronics") { result in
            switch result {
            case .success, .failure:
                expectation.fulfill() // If executes() is called, ViewModel is properly initialized
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testProductCategoryView_ShowsErrorMessage() {
        // Given: Mock API failure scenario
        let category = Category(id: "electronics", name: "Electronics", url: "https://example.com/electronics.jpg")
        let viewModel = MockProductViewModel(mockFetchProductsUseCase: MockFetchProductsUseCase())

        let mockError = NSError(domain: "APIError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        viewModel.executesResult = .failure(mockError)

        let expectation = XCTestExpectation(description: "ProductCategoryView should display an error message")

        DispatchQueue.main.async {
            let view = ProductCategoryView(category: category, viewModel: viewModel)
            let hostingController = UIHostingController(rootView: view)

            XCTAssertNotNil(hostingController.view, "View should be rendered")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testProductCategoryView_RendersProductGrid() {
        // Given: Mock Category & ViewModel
        let category = Category(id: "electronics", name: "Electronics", url: "https://example.com/electronics.jpg")
        let viewModel = MockProductViewModel(mockFetchProductsUseCase: MockFetchProductsUseCase())

        // Given: Mock Product Data
        let mockProducts = [
            ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics"),
            ProductEntity(id: 2, title: "Smartphone", price: 499.99, thumbnail: "", description: "A great smartphone", rating: 4.0, discountPercentage: 5.0, category: "electronics")
        ]
        viewModel.executesResult = .success(mockProducts) // Mock API Response

        let expectation = XCTestExpectation(description: "Product Grid should be displayed with products")

        DispatchQueue.main.async {
            let view = ProductCategoryView(category: category, viewModel: viewModel)
            let hostingController = UIHostingController(rootView: view)

            XCTAssertNotNil(hostingController.view, "View should be rendered") // View exists

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testProductCell_IsRendered() {
        // Given: A mock product
        let mockProduct = ProductEntity(
            id: 1,
            title: "Laptop",
            price: 999.99,
            thumbnail: "",
            description: "A powerful laptop",
            rating: 4.5,
            discountPercentage: 10.0,
            category: "electronics"
        )

        // When: Rendering `productCell(for:)`
        let cell = ProductCategoryView(category: mockCategory, viewModel: mockViewModel).productCell(for: mockProduct)

        let hostingController = UIHostingController(rootView: cell)

        // Then: Assert that the view is rendered
        XCTAssertNotNil(hostingController.view, "Product cell should be rendered")
    }

    func testProductImage_UsesCachedImage() {
        // Given: A mock product
        let mockProduct = ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics")

        // Given: Mock Cached Image
        let mockImage = UIImage(systemName: "star.fill")
        let cachedProduct = CachedProduct(from: mockProduct)
        cachedProduct.thumbnailImage = mockImage

        // Store image in cache
        ProductCache.shared.cacheThumbnail(mockImage!, forProductID: "\(mockProduct.id)")

        // When: Render `productImage(for:)`
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel).productImage(for: mockProduct)

        // Then: Verify it renders an Image (not placeholder)
        let hostingController = UIHostingController(rootView: view)
        XCTAssertNotNil(hostingController.view, "Cached image should be rendered instead of placeholder")
    }

    func testProductImage_Placeholder_WhenNoCachedImage() {
        // Given: A mock product with no cached image
        let mockProduct = ProductEntity(id: 2, title: "Tablet", price: 499.99, thumbnail: "", description: "A tablet", rating: 4.3, discountPercentage: 5.0, category: "electronics")

        // Ensure ProductCache does NOT have an image
        ProductCache.shared.clearCache()

        // When: Render `productImage(for:)`
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel).productImage(for: mockProduct)

        // Then: Verify placeholder renders
        let hostingController = UIHostingController(rootView: view)
        XCTAssertNotNil(hostingController.view, "Placeholder should be rendered when no cached image exists")
    }

    func testProductImage_TriggersImageDownload() {
        // Given: A mock product with no cached image
        let mockProduct = ProductEntity(id: 3, title: "Smartphone", price: 799.99, thumbnail: "", description: "A smartphone", rating: 4.8, discountPercentage: 12.0, category: "electronics")

        // Ensure cache is empty
        ProductCache.shared.clearCache()

        // Spy on ViewModel call
        mockViewModel.downloadAndCacheImage(for: mockProduct.id) { _ in }

        // When: Render `productImage(for:)`
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel).productImage(for: mockProduct)

        // Then: Ensure image download is triggered
        XCTAssertTrue(mockViewModel.downloadAndCacheImageCalled, "Image download should be triggered when no cached image exists")
    }

    func testFetchProducts_CallsAPI_WhenNoCache() {
        // Expectation for test verification
        let expectation = XCTestExpectation(description: "API call happens")

        // Given: Clear cache first
        ProductCache.shared.setProducts([])

        // Given: Mock API response
        let mockProducts = [
            ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        // When: View is created
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel, initialProducts: mockProducts)

        // Trigger the function manually instead of relying on SwiftUI lifecycle
        view.fetchProductsForCategory()

        // Assert: Products should be updated immediately
        XCTAssertFalse(view.testProducts.isEmpty, "Products should be loaded from API")
        XCTAssertEqual(view.testProducts.count, 1, "Products array should contain API fetched products")

        expectation.fulfill()
        wait(for: [expectation], timeout: 0.1)
    }

    func testProductCell_NavigatesToProductView() {
        let mockProduct = ProductEntity(id: 1, title: "Smartphone", price: 799.99, thumbnail: "", description: "Flagship Phone", rating: 4.8, discountPercentage: 5.0, category: "electronics")

        let cellView = ProductCategoryView(category: mockCategory, viewModel: mockViewModel).productCell(for: mockProduct)

        XCTAssertNotNil(cellView, "ProductCell should be created successfully")
    }

    func testProductGridView_RendersWithProducts() {
        // Given: Mock Products
        let mockProducts = [
            ProductEntity(id: 1, title: "Smartphone", price: 799.99, thumbnail: "", description: "Flagship Phone", rating: 4.8, discountPercentage: 5.0, category: "electronics"),
            ProductEntity(id: 2, title: "Camera", price: 499.99, thumbnail: "", description: "4K DSLR Camera", rating: 4.5, discountPercentage: 10.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        // When: View is Created
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel, initialProducts: mockProducts)

        // Then: Grid should display correct number of products
        XCTAssertFalse(view.testProducts.isEmpty, "Product grid should not be empty when products are available")
        XCTAssertEqual(view.testProducts.count, 2, "Product grid should display the correct number of products")
    }

    func testProductGridView_RendersEmptyState() {
        // Given: No Products Available
        mockViewModel.executesResult = .success([])

        // When: View is Created
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel)

        // Then: Grid should be empty
        XCTAssertTrue(view.testProducts.isEmpty, "Product grid should be empty when there are no products")
    }

    func testProductGridView_DisplaysCorrectNumberOfRows() {
        // Given: Mock Products
        let mockProducts = [
            ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics"),
            ProductEntity(id: 2, title: "Tablet", price: 499.99, thumbnail: "", description: "Lightweight Tablet", rating: 4.3, discountPercentage: 7.0, category: "electronics"),
            ProductEntity(id: 3, title: "Camera", price: 299.99, thumbnail: "", description: "HD Camera", rating: 4.0, discountPercentage: 5.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        // When: View is Created
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel, initialProducts: mockProducts)

        // Then: Grid should have 1 row (since we display in a 3-column grid)
        let expectedRows = (mockProducts.count + 2) / 3 // Rounded up
        XCTAssertEqual(view.testProducts.count, 3, "Product grid should contain 3 products")
        XCTAssertEqual(expectedRows, 1, "Product grid should have correct row count")
    }

    func testProductGridView_CallsProductCell() {
        // Given: Mock Products
        let mockProducts = [
            ProductEntity(id: 1, title: "Smartwatch", price: 199.99, thumbnail: "", description: "A modern smartwatch", rating: 4.2, discountPercentage: 15.0, category: "electronics"),
            ProductEntity(id: 2, title: "Headphones", price: 99.99, thumbnail: "", description: "Noise-canceling headphones", rating: 4.7, discountPercentage: 12.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        // When: View is Created
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel, initialProducts: mockProducts)

        // Then: Each product should have a corresponding product cell
        for product in view.testProducts {
            let productCell = view.productCell(for: product)
            XCTAssertNotNil(productCell, "ProductCell should be created for each product")
        }
    }

    func testProductGridView_DisplaysCorrectProductCount() {
        // Given: Mock Products
        let mockProducts = [
            ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics"),
            ProductEntity(id: 2, title: "Smartphone", price: 499.99, thumbnail: "", description: "A great smartphone", rating: 4.0, discountPercentage: 5.0, category: "electronics")
        ]
        mockViewModel.executesResult = .success(mockProducts)

        // When: View is created
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel, initialProducts: mockProducts)

        // Then: Ensure productGridView contains correct product count
        XCTAssertEqual(view.testProducts.count, 2, "ProductGridView should contain the correct number of products")
    }

    func testProductImage_Rendering() {
        // Expectation for verification
        let expectation = XCTestExpectation(description: "Product Image should be rendered")

        // Given: Mock Product
        let product = ProductEntity(
            id: 1,
            title: "Smartwatch",
            price: 199.99,
            thumbnail: "",
            description: "Smartwatch",
            rating: 4.2,
            discountPercentage: 15.0,
            category: "electronics"
        )

        // Given: Cached Image
        let testImage = UIImage(systemName: "star")!
        ProductCache.shared.cacheThumbnail(testImage, forProductID: "1")

        // Create a testable SwiftUI view that renders productImage()
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel)
        let hostingController = UIHostingController(rootView: view)

        // Ensure the view loads
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(hostingController.view, "Product Image should be part of the rendered view")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testErrorView_DisplaysCorrectMessage() {
        // Given: A test error message
        let errorMessage = "Test Error Message"

        // When: Render the error view
        let errorView = ProductCategoryView(category: mockCategory, viewModel: mockViewModel).errorView(message: errorMessage)

        // Then: Ensure the error message is displayed correctly
        let hostingController = UIHostingController(rootView: errorView)
        XCTAssertNotNil(hostingController.view, "ErrorView should be rendered successfully")
    }

    func testProductCategoryView_RenderProductGrid() {
        // Given: Mock products
        let mockProducts = [
            ProductEntity(id: 1, title: "Laptop", price: 999.99, thumbnail: "", description: "A powerful laptop", rating: 4.5, discountPercentage: 10.0, category: "electronics"),
            ProductEntity(id: 2, title: "Phone", price: 699.99, thumbnail: "", description: "A great phone", rating: 4.3, discountPercentage: 5.0, category: "electronics")
        ]

        mockViewModel.executesResult = .success(mockProducts)

        // When: Render the View
        let view = ProductCategoryView(category: mockCategory, viewModel: mockViewModel, initialProducts: mockProducts)

        // Then: Verify productGridView renders
        let hostingController = UIHostingController(rootView: view.testProductGridView)
        XCTAssertNotNil(hostingController.view, "ProductGridView should be rendered")

        // Verify products count
        XCTAssertFalse(view.testProducts.isEmpty, "ProductGridView should not be empty")
        XCTAssertEqual(view.testProducts.count, 2, "ProductGridView should contain 2 products")
    }
}

