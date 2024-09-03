//
//  ProfileViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation
import Network
import CoreData

protocol ProfileViewModelProtocol: AnyObject {
    var dataSource: ProfileDataSource? { get set }
    var onDataLoaded: (() -> Void)? { get set }
    var isLoading: Observable<Bool> { get set }
    var isConnected: Observable<Bool> { get set }
    func pushToPublic()
    func fetchData()
    func logout()
    func FetchedResultsController()
    func fetchOfflineProfile() -> OfflineProfile?
}

final class ProfileViewModel {

    private let coordinator: ProfileCoordinator
    private let networkManager: NetworkManagerProtocol
    private let keychain = KeychainManager.shared
    private var model: Account?
    var dataSource: ProfileDataSource?
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    private let networkMonitor = NWPathMonitor()
    var onDataLoaded: (() -> Void)?
    
    
    private let dataManager = CoreManager.shared
    var fetchedResultController: NSFetchedResultsController<OfflineProfile>?

 
    init(coordinator: ProfileCoordinator, networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
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
        networkManager.fetchAccountData { [weak self] result in
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
    
    func logout() {
        keychain.delete(forKey: "token")
        coordinator.finish()
    }
}

extension ProfileViewModel {

    func FetchedResultsController() {
        let fetchRequest: NSFetchRequest<OfflineProfile> = OfflineProfile.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "totalSpace", ascending: true)]
        
        let context = dataManager.persistentContainer.viewContext
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        
        try? fetchedResultController?.performFetch()
    }
    
    func fetchOfflineProfile() -> OfflineProfile? {
        let context = dataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<OfflineProfile> = OfflineProfile.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch OfflineProfile: \(error)")
            return nil
        }
    }
}
