//
//  ShopStopApp.swift
//  ShopStop
//
//  Created by Rahul Sharma on 21/01/25.
//

import SwiftUI

@main
struct ShopStopApp: App {
    private let container: DependencyContainer

    init() {
        self.container = DependencyContainer()
        let networkReachability = NetworkReachability()
        let apiService = APIService(
            baseURL: URL(string: "https://dummyjson.com/")!,
            session: URLSession.shared,
            networkReachability: networkReachability
        ) as APIServiceProtocol
        let productCache = ProductCache.shared

        // Initial required Repositories
        let categoryRepository = CategoryRepositoryImpl(apiService: apiService) as CategoryRepository
        let productRepository = ProductRepositoryImpl(apiService: apiService, productCache: productCache) as ProductRepository

        let fetchCategoriesUseCase = FetchCategoriesUseCase(repository: categoryRepository) as FetchCategoriesUseCaseProtocol
        let fetchProductsUseCase = FetchProductsUseCase(repository: productRepository) as FetchProductsUseCaseProtocol


        // Inject Initial Dependencies
        container.register(apiService)
        container.register(categoryRepository)
        container.register(productCache)
        container.register(productRepository)
        container.register(fetchCategoriesUseCase)
        container.register(fetchProductsUseCase)
    }

    var body: some Scene {
        WindowGroup {
            ProductBrandsScreen(container: container)
        }
    }
}
