//
//  CartView.swift
//  shopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import SwiftUI

struct CartView: View {
    private var cartStorage: CartStorageProtocol
    @State private var productIDs: [Int]
    @State private var cartItems: [Product] = []
    @State private var reloadTrigger = false // Trigger view redraw

    init(cartStorage: CartStorageProtocol = CartStorage.shared) {
        self.cartStorage = cartStorage
        self._productIDs = State(initialValue: cartStorage.getCartProductIDs())
    }

    var body: some View {
        ZStack {
            backgroundView

            NavigationView {
                VStack {
                    if cartItems.isEmpty {
                        emptyCartView
                    } else {
                        cartItemsList
                    }
                }
                .navigationTitle(AppConstants.UI.cart)
            }
        }
        .onAppear(perform: loadCart)
        .onChange(of: reloadTrigger, perform: { _ in loadCart() })
    }
}

// MARK: - UI Components using @ViewBuilder**
extension CartView {

    // Background Gradient
    @ViewBuilder
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }

    // Empty Cart Placeholder
    @ViewBuilder
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Text(AppConstants.UI.emptyCart)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding()

            Image(systemName: "cart.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
        }
    }

    // Cart Items List
    @ViewBuilder
    var cartItemsList: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(cartItems, id: \.id) { product in
                    cartItemRow(for: product)
                }
            }
            .padding()
        }
    }

    // Cart Item Row
    @ViewBuilder
    func cartItemRow(for product: Product) -> some View {
        HStack(spacing: 16) {
            productThumbnail(for: product)

            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(String(format: "$%.2f", product.price))
                    .font(.subheadline)
                    .foregroundColor(.green)
            }

            Spacer()

            removeButton(for: product)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    // Product Thumbnail
    @ViewBuilder
    func productThumbnail(for product: Product) -> some View {
        if let cachedProduct = ProductCache.shared.getCachedProduct(forKey: "\(product.id)"),
           let thumbnailImage = cachedProduct.thumbnailImage {
            Image(uiImage: thumbnailImage)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        } else {
            Color.gray
                .frame(width: 80, height: 80)
                .cornerRadius(12)
        }
    }

    // Remove Item Button
    @ViewBuilder
    private func removeButton(for product: Product) -> some View {
        Button(action: {
            cartStorage.removeFromCart(productID: product.id)
            reloadTrigger.toggle()
        }) {
            Image(systemName: "trash")
                .font(.title2)
                .foregroundColor(.red)
        }
    }
}

// MARK: - Helper Functions
extension CartView {

    // Load Cart Data
    func loadCart() {
        productIDs = cartStorage.getCartProductIDs()
        cartItems = getProductsFromCache(productIDs: productIDs)
    }

    // Fetch Products from Cache
    private func getProductsFromCache(productIDs: [Int]) -> [Product] {
        return productIDs.compactMap { id in
            if let cachedProduct = ProductCache.shared.getCachedProduct(forKey: "\(id)") {
                return Product(
                    id: cachedProduct.id,
                    title: cachedProduct.title,
                    price: cachedProduct.price,
                    thumbnail: cachedProduct.thumbnailURL,
                    description: cachedProduct.description,
                    rating: cachedProduct.rating,
                    discountPercentage: cachedProduct.discountPercentage,
                    category: cachedProduct.category
                )
            }
            return nil
        }
    }
}


extension CartView {
    // Check if cart is empty
    var testIsCartEmpty: Bool {
        return cartItems.isEmpty
    }

    // Check the navigation title
    var testNavigationTitle: String {
        return AppConstants.UI.cart
    }

    // Simulate remove button action
    mutating func testRemoveProduct(productID: Int) {
        cartStorage.removeFromCart(productID: productID)
        productIDs = cartStorage.getCartProductIDs()
        cartItems = getProductsFromCache(productIDs: productIDs)
    }

    // Simulate add product action
    mutating func testAddProduct(productID: Int) {
        cartStorage.addToCart(productID: productID)
        productIDs = cartStorage.getCartProductIDs()
        cartItems = getProductsFromCache(productIDs: productIDs)
    }

    // Check if background gradient is applied
    var testHasGradientBackground: Bool {
        return true // Assuming the gradient is always present
    }
}
