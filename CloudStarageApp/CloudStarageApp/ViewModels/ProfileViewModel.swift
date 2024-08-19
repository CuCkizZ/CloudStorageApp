//
//  ProfileViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation
import Network

protocol ProfileViewModelProtocol: AnyObject {
    var onDataLoaded: (() -> Void)? { get set }
    var dataSource: ProfileDataSource? { get set }
    var isLoading: Observable<Bool> { get set }
    var isConnected: Observable<Bool> { get set }
    func pushToPublic()
    func fetchData()
    func logOut()
    func paggination(title: String, path: String)
}

final class ProfileViewModel {
    
    private let coordinator: ProfileCoordinator
    private var model: Account?
    var dataSource: ProfileDataSource?
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    private let networkMonitor = NWPathMonitor()
    var onDataLoaded: (() -> Void)?
 
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        fetchData()
        startMonitoringNetwork()
    }
    
    func startMonitoringNetwork() {
        let queue = DispatchQueue.global(qos: .background)
        networkMonitor.start(queue: queue)
        networkMonitor.pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                switch path.status {
                case .unsatisfied:
                    self.isConnected.value = false
                case .satisfied:
                    self.isConnected.value = true
                case .requiresConnection:
                    self.isConnected.value = true
                @unknown default:
                    break
            }
        }
    }
    
}

extension ProfileViewModel: ProfileViewModelProtocol {
    
    func fetchData() {
        NetworkManager.shared.fetchAccountData { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.dataSource = profile
                    self.onDataLoaded?()
                case .failure(let error):
                    print("data viewmodel error: \(error)")
                }
                
            }
        }
    }
    
    func pushToPublic() {
        coordinator.goToPublic()
    }
    
    func paggination(title: String, path: String) {
        coordinator.paggination(path: path, title: title)
    }
    
    func logOut() {
        coordinator.finish()
    }
}
