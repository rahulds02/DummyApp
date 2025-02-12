//
//  ProductCategoryView.swift
//  ShopStop
//
//  Created by Rahul Sharma on 24/01/25.
//

import SwiftUI

func debugLog(_ message: String) {
#if DEBUG
    print("DEBUG: \(message)")
#endif
}

struct ProductCategoryView<ProdViewModel>: View where ProdViewModel: ProductViewModelProtocol {
    let category: Category
    @State private var products: [ProductEntity] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var reloadView: Bool = false
    @StateObject private var productViewModel: ProdViewModel
    
    init(category: Category, viewModel: ProdViewModel, initialProducts: [ProductEntity] = []) {
        self.category = category
        self._productViewModel = StateObject(wrappedValue: viewModel)
        self._products = State(initialValue: initialProducts)
        debugLog("ProductCategoryView initialized with category: \(category.name)")
    }
    
    var testErrorMessage: String? {
        errorMessage
    }
    
    var testProducts: [ProductEntity] {
        products
    }
    
    var testIsLoading: Bool {
        isLoading
    }
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack {
                if isLoading {
                    loadingView
                } else if let errorMessage = errorMessage {
                    errorView(message: errorMessage)
                } else {
                    productGridView
                }
            }
            .navigationTitle(category.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            fetchProductsForCategory()
        }
        .onChange(of: reloadView) { }
    }
}

extension ProductCategoryView {
    
    // Background View
    @ViewBuilder
    var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1), Color.white]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    // Loading View
    @ViewBuilder
    var loadingView: some View {
        ProgressView(AppConstants.UI.homeLoadingMessage)
            .padding()
    }
    
    // Error View
    @ViewBuilder
    func errorView(message: String) -> some View {
        Text("Error: \(message)")
            .foregroundColor(.red)
            .padding()
    }
    
    // Product Grid
    @ViewBuilder
    var productGridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(products, id: \.id) { product in
                    productCell(for: product)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .onAppear {
            debugLog("productGridView has been rendered")
        }
    }
    
    // Product Cell View
    @ViewBuilder
    func productCell(for product: ProductEntity) -> some View {
        NavigationLink(destination: ProductView(productId: product.id)) {
            VStack {
                productImage(for: product)
                
                Text(product.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    // Product Image Handling
    @ViewBuilder
    func productImage(for product: ProductEntity) -> some View {
        if let cachedProduct = ProductCache.shared.getCachedProduct(forKey: "\(product.id)"),
           let thumbnailImage = cachedProduct.thumbnailImage {
            Image(uiImage: thumbnailImage)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .onAppear {
                    debugLog("Using Cached Image for Product ID: \(product.id)")
                }
        } else {
            Color.gray
                .frame(width: 100, height: 100)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .onAppear {
                    debugLog("No Cached Image! Downloading for Product ID: \(product.id)")
                    productViewModel.downloadAndCacheImage(for: product.id) { result in
                        if case .success = result {
                            debugLog("Image Download Successful for Product ID: \(product.id)")
                            reloadView.toggle()
                        }
                        else {
                            debugLog("Image Download Failed for Product ID: \(product.id)")
                        }
                    }
                }
        }
    }
    
    // Fetch Products
    func fetchProductsForCategory() {
        debugLog("fetchProductsForCategory")
        let cachedProducts = ProductCache.shared.getProducts(forCategory: category.id)
        
        if !cachedProducts.isEmpty {
            self.products = cachedProducts
            self.isLoading = false
            return
        }
        
        isLoading = true
        
        self.productViewModel.executes(categoryID: category.id) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedProducts):
                    debugLog("fetchProductsForCategory success")
                    ProductCache.shared.setProducts(fetchedProducts)
                    self.products = Array(fetchedProducts.prefix(10))
                case .failure(let error):
                    debugLog("fetchProductsForCategory failure")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

extension ProductCategoryView {
    var productList: [ProductEntity] {
        return products
    }
    
    var testProductGridView: some View {
        productGridView
    }
    
    var testViewModel: any ProductViewModelProtocol {
        return productViewModel
    }
}
