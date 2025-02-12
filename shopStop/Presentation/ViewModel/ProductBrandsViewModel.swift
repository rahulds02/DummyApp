//
//  SplashScreenViewModel.swift
//  ShopStop
//
//  Created by Rahul Sharma on 23/01/25.
//
import SwiftUI

protocol ProductBrandsViewModelProtocol: ObservableObject {
    var categories: [Category] { get }
    var randomProducts: [ProductEntity] { get }
    var exclusiveOffers: [ProductEntity] { get }
    var popularPicks: [ProductEntity] { get }
    var isDataReady: Bool { get }
    var showAlert: Bool { get }
    var alertMessage: String { get }
}

class ProductBrandsViewModel: ProductBrandsViewModelProtocol {
    @Published var categories: [Category] = []
    @Published var randomProducts: [ProductEntity] = []
    @Published var exclusiveOffers: [ProductEntity] = []
    @Published var popularPicks: [ProductEntity] = []
    @Published var isDataReady: Bool = false
    @Published var showAlert: Bool = false // Tracks if the alert should be shown
    @Published var alertMessage: String = "" // Stores the alert message

    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol
    private let fetchProductsUseCase: FetchProductsUseCaseProtocol

    init(fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol, fetchProductsUseCase: FetchProductsUseCaseProtocol) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.fetchProductsUseCase = fetchProductsUseCase
    }

    func loadInitialData() {
        // APIService.shared.fetchCategories { [weak self] result in
        fetchCategoriesUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.fetchProductsForCategories(categories)
                case .failure(let error):
                    if let apiError = error as? APIError {
                        self?.handleAPIError(apiError)
                    } else {
                        self?.alertMessage = error.localizedDescription
                        self?.showAlert = true
                    }
                }
            }
        }
    }

    private func handleAPIError(_ error: APIError) {
        switch error {
        case .noInternetConnection:
            self.alertMessage = "No internet connection. Please check your connection and try again."
        case .requestFailed:
            self.alertMessage = "The request failed. Please try again."
        case .decodingError:
            self.alertMessage = "Failed to decode the response. Please try again later."
        case .custom(let message):
            self.alertMessage = message
        default:
            self.alertMessage = "An unknown error occurred. Please try again."
        }
        self.showAlert = true // Trigger the alert
    }

    private func fetchProductsForCategories(_ categories: [Category]) {
        let group = DispatchGroup()
        var updatedCategories = categories
        var allProducts: [Product] = []

        for i in 0..<categories.count {
            group.enter()
            fetchProductsUseCase.executeAndFetch(categoryID: categories[i].id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let products):
                        if let firstImage = products.first?.thumbnail {
                            updatedCategories[i].url = firstImage
                        }
                        allProducts.append(contentsOf: products)
                    case .failure(let error):
                        print("Error fetching products for category \(categories[i].id): \(error)")
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.categories = updatedCategories
            self.handleFetchedProducts(allProducts)
        }
    }

    private func handleFetchedProducts(_ products: [Product]) {
        // Assign random products for various sections
        let productEntities = ProductMapper.mapDomainToEntity(products)

        self.randomProducts = Array(productEntities.shuffled().prefix(10))
        self.exclusiveOffers = Array(productEntities.shuffled().prefix(5))
        self.popularPicks = Array(productEntities.shuffled().prefix(5))
        self.isDataReady = true // Notify that the data is ready
    }
}


