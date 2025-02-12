//
//  Categoryrepository.swift
//  ShopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

protocol CategoryRepository {
    func fetchCategories(completion: @escaping (Result<[CategoryEntity], Error>) -> Void) //Return `CategoryEntity`
}

class CategoryRepositoryImpl: CategoryRepository {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func fetchCategories(completion: @escaping (Result<[CategoryEntity], Error>) -> Void) {
        apiService.fetchCategories { result in
            switch result {
            case .success(let categoryDTOs):
                let categoryEntities = CategoryMapper.mapToEntity(categoryDTOs) //Convert DTOs to Entities
                completion(.success(categoryEntities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
