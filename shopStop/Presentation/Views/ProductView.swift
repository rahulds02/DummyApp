import SwiftUI

struct ProductView: View {
    let productId: Int
    @State var isAddedToCart: Bool = false

    init(productId: Int) {
        self.productId = productId
        debugLog("Cart contains product \(productId): \(CartStorage.shared.getCartProductIDs().contains(productId))") // Debug Log
        self._isAddedToCart = State(initialValue: CartStorage.shared.getCartProductIDs().contains(productId))
    }

    var body: some View {
        if let cachedProduct = ProductCache.shared.getCachedProduct(forKey: "\(productId)") {
            ScrollView {
                VStack(spacing: 16) {
                    productImage(for: cachedProduct)
                    productTitle(for: cachedProduct)
                    productPrice(for: cachedProduct)
                    productRating(for: cachedProduct)
                    productDescription(for: cachedProduct)
                    addToCartButton(for: cachedProduct)
                    Spacer()
                }
            }
            .background(backgroundView)
            .navigationTitle(AppConstants.UI.productDetailsTitle)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            productNotFoundView
        }
    }
}

// MARK: - UI Components using @ViewBuilder
extension ProductView {

    // Product Image
    @ViewBuilder
    func productImage(for cachedProduct: CachedProduct) -> some View {
        if let thumbnailImage = cachedProduct.thumbnailImage {
            Image(uiImage: thumbnailImage)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                .padding(.top)
        }
    }

    // Product Title
    @ViewBuilder
    func productTitle(for cachedProduct: CachedProduct) -> some View {
        Text(cachedProduct.title)
            .font(.title2)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .padding(.horizontal)
    }

    // Product Price
    @ViewBuilder
    func productPrice(for cachedProduct: CachedProduct) -> some View {
        Text("$\(cachedProduct.price, specifier: "%.2f")")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.green)
    }

    // Product Rating with Stars
    @ViewBuilder
    func productRating(for cachedProduct: CachedProduct) -> some View {
        HStack(spacing: 4) {
            Text(AppConstants.UI.ratingLabel)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= getStarCount(for: cachedProduct.rating) ? "star.fill" : "star")
                        .foregroundColor(star <= getStarCount(for: cachedProduct.rating) ? .yellow : .gray)
                }
            }
        }
    }

    // Product Description
    @ViewBuilder
    func productDescription(for cachedProduct: CachedProduct) -> some View {
        Text(cachedProduct.descriptions)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
    }

    // Add to Cart Button
    @ViewBuilder
    func addToCartButton(for cachedProduct: CachedProduct) -> some View {
        Button(action: {
            if isAddedToCart {
                CartStorage.shared.removeFromCart(productID: productId)
            } else {
                CartStorage.shared.addToCart(productID: productId)
            }
            isAddedToCart.toggle()
        }) {
            Text(isAddedToCart ? AppConstants.UI.addedToCart : AppConstants.UI.addToCart)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isAddedToCart ? Color.green : Color.green.opacity(0.5)) // Dynamic color
                .cornerRadius(12)
        }
        .padding(.horizontal)
        .onAppear {
            let cartProductIDs = CartStorage.shared.getCartProductIDs()
            isAddedToCart = cartProductIDs.contains(productId)
        }
    }

    // Background View
    var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }

    // Product Not Found View
    @ViewBuilder
    var productNotFoundView: some View {
        VStack {
            Text(AppConstants.UI.productNotFound)
                .font(.headline)
                .foregroundColor(.red)
                .padding()
        }
    }

    // Function to calculate number of stars based on rating
    func getStarCount(for rating: Double) -> Int {
        switch rating {
        case 0..<1: return 0
        case 1..<2: return 1
        case 2..<3: return 2
        case 3..<4: return 3
        case 4..<5: return 4
        default: return 5
        }
    }

    func addToCart() {
        if isAddedToCart {
            CartStorage.shared.removeFromCart(productID: productId)
        } else {
            CartStorage.shared.addToCart(productID: productId)
        }
        debugLog("Cart State Updated: \(isAddedToCart)")
        isAddedToCart.toggle()
    }
}

