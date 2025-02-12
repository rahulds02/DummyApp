//
//  SplashScreenView.swift
//  ShopStop
//
//  Created by Rahul Sharma on 23/01/25.
//

import SwiftUI

struct ProductBrandsScreen: View {
    private let container: DependencyContainer
    
    @StateObject private var viewModel: ProductBrandsViewModel
    @StateObject private var productViewModel: ProductViewModel
    @State private var isAnimating = false
    @State private var showAlert = false // Tracks if the alert should be shown
    @State private var alertMessage = "" // Stores the alert message

    init(container: DependencyContainer) {
        self.container = container
        
        _viewModel = StateObject(wrappedValue: ProductBrandsViewModel(fetchCategoriesUseCase: container.resolve()!,
                                 fetchProductsUseCase: container.resolve()!))
        
        _productViewModel = StateObject(wrappedValue: ProductViewModel(fetchProductsUseCase: container.resolve()!)
        )
    }

    var body: some View {
        if viewModel.isDataReady {
            ContentView(viewModel: viewModel, productViewModel: productViewModel)
        } else {
            ZStack {
                Color.blue // Background color
                    .ignoresSafeArea()

                VStack {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 1.5), value: isAnimating)

                    Text(AppConstants.UI.appTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 2.0), value: isAnimating)
                }
            }
            .onAppear {
                isAnimating = true
                viewModel.loadInitialData()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(AppConstants.UI.error),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(AppConstants.UI.ok))
                )
            }
            .onChange(of: viewModel.alertMessage) { _, newValue in
                if !newValue.isEmpty {
                    alertMessage = newValue
                    showAlert = true
                }
            }
        }
    }
}

