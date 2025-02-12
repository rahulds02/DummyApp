//
//  TwoRowScrollView.swift
//  ShopStop
//
//  Created by Rahul Sharma on 21/01/25.
//

import SwiftUI

// MARK: - Category Row
struct CategoryRow<ProdViewModel>: View where ProdViewModel: ProductViewModelProtocol {
    let categories: [Category]
    private var productViewModel: ProdViewModel

    init(categories: [Category], viewModel: ProdViewModel) {
        self.categories = categories
        self.productViewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 16) {
            ForEach(categories, id: \.id) { category in
                categoryCard(for: category)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Two Row Scroll View
struct TwoRowScrollView<ProdViewModel>: View where ProdViewModel: ProductViewModelProtocol {
    let categories: [Category]
    private var productViewModel: ProdViewModel

    init(categories: [Category], viewModel: ProdViewModel) {
        self.categories = categories
        self.productViewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader
            scrollableCategories
        }
        .padding(.vertical, 10)
    }
}

// MARK: - UI Components Using @ViewBuilder
extension TwoRowScrollView {

    // Section Header
    @ViewBuilder
    private var sectionHeader: some View {
        Text(AppConstants.UI.homeCategoriesTitle)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.horizontal)
    }

    // Scrollable Categories
    @ViewBuilder
    private var scrollableCategories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 16) {
                firstCategoryRow
                secondCategoryRow
            }
            .padding(.vertical, 8)
            .background(scrollBackground)
            .padding(.horizontal)
        }
    }

    // First Row
    @ViewBuilder
    private var firstCategoryRow: some View {
        if !categories.isEmpty {
            CategoryRow(categories: Array(categories.prefix(categories.count / 2)), viewModel: productViewModel)
        }
    }

    // Second Row
    @ViewBuilder
    private var secondCategoryRow: some View {
        if categories.count > 1 {
            CategoryRow(categories: Array(categories.suffix(categories.count - categories.count / 2)), viewModel: productViewModel)
        }
    }

    // Scroll Background
    private var scrollBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

// MARK: - Category Card
extension CategoryRow {
    @ViewBuilder
    private func categoryCard(for category: Category) -> some View {
        NavigationLink(destination: ProductCategoryView(category: category, viewModel: productViewModel)) {
            VStack {
                categoryImage(for: category)
                categoryTitle(for: category)
            }
            .padding(6)
            .background(cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }

    // Category Image
    @ViewBuilder
    private func categoryImage(for category: Category) -> some View {
        AsyncImage(url: URL(string: category.url)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 80)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.7), lineWidth: 1)
                )
        } placeholder: {
            Color.gray
                .frame(width: 100, height: 80)
                .cornerRadius(8)
        }
    }

    // Category Title
    @ViewBuilder
    private func categoryTitle(for category: Category) -> some View {
        Text(category.name)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .lineLimit(1)
            .padding(.top, 4)
    }

    // Card Background
    private var cardBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.05)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
