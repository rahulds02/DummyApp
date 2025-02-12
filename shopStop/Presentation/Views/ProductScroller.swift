//
//  TwoRowScrollView.swift
//  ShopStop
//
//  Created by Rahul Sharma on 21/01/25.
//

import SwiftUI

struct ProductScroller<ProdViewModel>: View where ProdViewModel: ProductViewModelProtocol {
    var productIDs: [Int]
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()

    @State private var selectedIndex: Int = 0 // Controls the currently displayed product
    @ObservedObject private var productViewModel: ProdViewModel

    init(productIDs: [Int], viewModel: ProdViewModel) {
        self.productIDs = productIDs
        self._productViewModel = ObservedObject(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            backgroundView
            VStack {
                productCarousel
                Spacer()
                pageIndicator
                    .padding(.bottom, 8)
            }
        }
        .padding(.horizontal)
        .onAppear {
            preloadImages()
        }
    }
}

// MARK: - UI Components using @ViewBuilder
extension ProductScroller {

    // Background Gradient
    @ViewBuilder
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }

    // Product Carousel - TabView
    @ViewBuilder
    private var productCarousel: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(productIDs.enumerated()), id: \.element) { index, id in
                productCard(for: id)
                    .tag(index) // Ensure the tag matches the index for TabView selection
            }
        }
        .frame(height: 250)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onReceive(timer) { _ in
            withAnimation {
                selectedIndex = (selectedIndex + 1) % productIDs.count
            }
        }
    }

    // Product Card
    @ViewBuilder
    private func productCard(for id: Int) -> some View {
        if let cachedProduct = ProductCache.shared.getCachedProduct(forKey: "\(id)") {
            NavigationLink(destination: ProductView(productId: cachedProduct.id)) {
                VStack {
                    productImage(for: cachedProduct)
                    productTitle(for: cachedProduct)
                }
                .padding(.horizontal)
                .background(backgroundView)
                .cornerRadius(16)
            }
        } else {
            placeholderCard
        }
    }

    // Product Image
    @ViewBuilder
    private func productImage(for cachedProduct: CachedProduct) -> some View {
        if let thumbnailImage = cachedProduct.thumbnailImage {
            Image(uiImage: thumbnailImage)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
                .cornerRadius(16)
        } else {
            Color.gray
                .frame(width: 300, height: 200)
                .cornerRadius(16)
                .onAppear {
                    productViewModel.downloadAndCacheImage(for: cachedProduct.id) { _ in }
                }
        }
    }

    // Product Title
    @ViewBuilder
    private func productTitle(for cachedProduct: CachedProduct) -> some View {
        Text(cachedProduct.title)
            .font(.headline)
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
    }

    // Placeholder Card (For missing cached products)**
    @ViewBuilder
    private var placeholderCard: some View {
        VStack {
            Color.gray
                .frame(width: 300, height: 200)
                .cornerRadius(16)
            Text(AppConstants.UI.homeLoadingMessage)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    // Page Indicator (Dots)**
    @ViewBuilder
    private var pageIndicator: some View {
        HStack {
            ForEach(productIDs.indices, id: \.self) { index in
                Circle()
                    .fill(selectedIndex == index ? Color.blue : Color.gray)
                    .frame(width: 10, height: 10)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
            }
        }
    }

    // Preload Images on Appear
    private func preloadImages() {
        productIDs.forEach { id in
            productViewModel.downloadAndCacheImage(for: id) { _ in }
        }
    }
}

