//
//  NetworkMonitoring.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 09.08.2024.
//

import Foundation
import Network

private let labelMonitor = "NetworkConnectivityMonitor"
private let statusChandeg = "connectivityStatusChanged"

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue(label: labelMonitor)
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false
    private var isExpensive = false
    private var currentConnectionType: NWInterface.InterfaceType?
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
            
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: statusChandeg)
}

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
            .other,
            .wifi,
            .cellular,
            .loopback,
            .wiredEthernet
        ]
}
