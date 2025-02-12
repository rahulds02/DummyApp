//
//  DependencyContainer.swift
//  ShopStop
//
//  Created by Rahul Sharma on 27/01/25.
//

import Foundation

protocol DependencyResolver {
    func resolve<T>() -> T?
}

class DependencyContainer: DependencyResolver {
    static let shared = DependencyContainer()
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }
    
    func resolve<T>() -> T? {
        let key = String(describing: T.self)
        return dependencies[key] as? T
    }
}


