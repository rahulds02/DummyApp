import SwiftUI

struct ExclusiveOffersView<ProdViewModel>: View where ProdViewModel: ProductViewModelProtocol {
    let products: [ProductEntity] // Uses `ProductEntity`
    private var productViewModel: ProdViewModel
    @State private var reDrawView: Bool = false // Redraw trigger for image updates

    init(products: [ProductEntity], viewModel: ProdViewModel) {
        self.products = products
        self.productViewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader
            productGrid
        }
        .background(backgroundView)
        .onChange(of: reDrawView) { }
    }
}

// MARK: - UI Components using @ViewBuilder
extension ExclusiveOffersView {

    // Section Header
    @ViewBuilder
    private var sectionHeader: some View {
        Text(AppConstants.UI.homeExclusiveOffersTitle)
            .accessibilityIdentifier("ExclusiveOffersTitle")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.horizontal)
            .padding(.top, 8)
    }

    // Product Grid
    @ViewBuilder
    private var productGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
            ForEach(products.prefix(4), id: \.id) { product in
                productCard(for: product)
            }
        }
        .padding(.horizontal)
    }

    // Product Card
    @ViewBuilder
    private func productCard(for product: ProductEntity) -> some View {
        NavigationLink(destination: ProductView(productId: product.id)) {
            VStack {
                productImage(for: product)
                productTitle(for: product)
            }
            .padding(8)
            .background(cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // Product Image Handling
    @ViewBuilder
    private func productImage(for product: ProductEntity) -> some View {
        if let cachedProduct = ProductCache.shared.getCachedProduct(forKey: "\(product.id)"),
           let thumbnailImage = cachedProduct.thumbnailImage {
            Image(uiImage: thumbnailImage)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .accessibilityIdentifier("ProductThumbnail_\(product.id)")
        } else {
            Color.gray
                .frame(width: 140, height: 140)
                .cornerRadius(12)
                .onAppear {
                    productViewModel.downloadAndCacheImage(for: product.id) { result in
                        if case .success = result {
                            reDrawView.toggle()
                        }
                    }
                }
        }
    }

    // Product Title
    @ViewBuilder
    private func productTitle(for product: ProductEntity) -> some View {
        Text(product.title)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .accessibilityIdentifier("ProductTitle_\(product.id)")
    }

    // Card Background
    private var cardBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.05)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // Background View
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
