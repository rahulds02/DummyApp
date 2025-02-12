//
//  NetworkReachability.swift
//  shopStop
//
//  Created by Rahul Sharma on 28/01/25.
//


import Network

protocol NetworkReachabilityProtocol {
    func isInternetAvailable() -> Bool
}

class NetworkReachability: NetworkReachabilityProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    // Check if the internet is available
    func isInternetAvailable() -> Bool {
        return isConnected
    }
}
