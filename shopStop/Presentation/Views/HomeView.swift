//
//  HomeView.swift
//  ShopStop
//
//  Created by Rahul Sharma on 21/01/25.
//

import SwiftUI

struct HomeView<ProdBrandsViewModel, ProdViewModel>: View where ProdBrandsViewModel: ProductBrandsViewModelProtocol, ProdViewModel: ProductViewModelProtocol {
    private var viewModel: ProdBrandsViewModel
    private var productViewModel: ProdViewModel
    
    init(viewModel: ProdBrandsViewModel, productViewModel: ProdViewModel) {
        self.viewModel = viewModel
        self.productViewModel = productViewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundView
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        if !viewModel.randomProducts.isEmpty {
                            productScrollerSection
                        }
                        
                        if !viewModel.categories.isEmpty {
                            categoriesSection
                        }
                        
                        if !viewModel.exclusiveOffers.isEmpty {
                            exclusiveOffersSection
                        }
                        
                        if !viewModel.popularPicks.isEmpty {
                            popularPicksSection
                        }
                    }
                    .padding(.top)
                }
            }
        }
    }
}

// MARK: - UI Components using @ViewBuilder
extension HomeView {
    
    // Background View
    @ViewBuilder
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(.systemTeal).opacity(0.1), Color(.systemBlue).opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // Product Scroller
    @ViewBuilder
    private var productScrollerSection: some View {
        VStack(alignment: .leading) {
            ProductScroller(productIDs: viewModel.randomProducts.map { $0.id }, viewModel: productViewModel)
                .padding(.bottom, 10)
        }
    }
    
    // Categories Section
    @ViewBuilder
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            TwoRowScrollView(categories: viewModel.categories, viewModel: productViewModel)
                .padding(.horizontal)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    // Exclusive Offers Section (Fixed)
    @ViewBuilder
    private var exclusiveOffersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ExclusiveOffersView(
                products: viewModel.exclusiveOffers,
                viewModel: productViewModel
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.yellow.opacity(0.1))
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    // Popular Picks Section (Fixed)
    @ViewBuilder
    private var popularPicksSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            PopularPicksView(
                products: viewModel.popularPicks, // Convert [ProductEntity] → [Product]
                viewModel: productViewModel
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green.opacity(0.1))
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}
