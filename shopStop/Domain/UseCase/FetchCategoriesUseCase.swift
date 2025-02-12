//
//  FetchCategoriesUseCase.swift
//  ShopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

protocol FetchCategoriesUseCaseProtocol {
    func execute(completion: @escaping (Result<[Category], Error>) -> Void)
}

class FetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {
    private let repository: CategoryRepository

    init(repository: CategoryRepository) {
        self.repository = repository
    }

    // Fetch Categories (`CategoryEntity` → `Category`)
    func execute(completion: @escaping (Result<[Category], Error>) -> Void) {
        repository.fetchCategories { result in
            switch result {
            case .success(let categoryEntities):
                //Convert `CategoryEntity` to `Category` Before Returning
                let categories = CategoryMapper.mapToDomain(categoryEntities)
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
