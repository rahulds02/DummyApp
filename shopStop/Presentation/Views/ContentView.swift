//
//  ContentView.swift
//  ShopStop
//
//  Created by Rahul Sharma on 21/01/25.
//

import SwiftUI

struct ContentView<ProdBrandsViewModel, ProdViewModel>: View where ProdBrandsViewModel: ProductBrandsViewModelProtocol, ProdViewModel: ProductViewModelProtocol {
    @State private var selectedIndex = 0
    private var splashViewModel: ProdBrandsViewModel
    private var productViewModel: ProdViewModel

    init(viewModel: ProdBrandsViewModel, productViewModel: ProdViewModel) {
        self.splashViewModel = viewModel
        self.productViewModel = productViewModel
    }

    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeView(viewModel: splashViewModel, productViewModel: productViewModel)
            .tabItem {
                Image(systemName: "house.fill")
                Text(AppConstants.UI.home)
            }
            .tag(0)

            CartView()
                .tabItem {
                    Image(systemName: "cart.fill") // Cart icon
                    Text(AppConstants.UI.cart)
                }
                .tag(1)
        }
    }
}


