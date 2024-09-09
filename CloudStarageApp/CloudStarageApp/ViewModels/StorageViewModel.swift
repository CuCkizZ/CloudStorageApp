//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Foundation
import Network
import CoreData

protocol StorageViewModelProtocol: BaseCollectionViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[CellDataModel]> { get set }
    func returnItems(at indexPath: IndexPath) -> OfflineStorage?
    func fetchCurrentData(navigationTitle: String, path: String)
    func paggination(title: String, path: inout String)
}

final class StorageViewModel {
    
    private let coordinator: StorageCoordinator
    private let networkManager: NetworkManagerProtocol
    
    private let keychain = KeychainManager.shared
    private let dataManager = CoreManager.shared
    private var model: [Item] = []
    private let networkMonitor = NWPathMonitor()
    private var path: String?
    
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var fetchedResultController: NSFetchedResultsController<OfflineStorage>?
    var isSharing: Observable<Bool> = Observable(nil)
    var isPublished: (() -> IndexPath)?
    
    init(coordinator: StorageCoordinator, networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
        startMonitoringNetwork()
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}
    
extension StorageViewModel: StorageViewModelProtocol {
 
    //    MARK: Network
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        networkManager.fetchData() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let file):
                    self.model = file
                    self.mapModel()
                    self.isLoading.value = false
                case .failure(let error):
                    print("model failrue: \(error)")
                }
            }
        }
    }
    
    func fetchCurrentData(navigationTitle: String, path: String) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        networkManager.fetchCurentData(path: path) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let file):
                    self.model = file
                    self.mapModel()
                    self.isLoading.value = false
                case .failure(let error):
                    print("model failrue: \(error)")
                }
            }
        }
    }
    
    func publishResource(_ path: String, indexPath: IndexPath) {
        networkManager.toPublicFile(path: path)
        isSharing.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
            if isSharing.value == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.presentAvc(indexPath: indexPath)
                }
            }
        }
    }
    
    func unpublishResource(_ path: String) {
        networkManager.unpublishFile(path)
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
    
    func publishResource(_ path: String) {
        networkManager.toPublicFile(path: path)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func deleteFile(_ name: String) {
        networkManager.deleteReqest(name: name)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func createNewFolder(_ name: String) {
        if name.isEmpty == true {
            networkManager.createNewFolder(StrGlobalConstants.publicTitle)
        } else {
            networkManager.createNewFolder(name)
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func renameFile(oldName: String, newName: String) {
        networkManager.renameFile(oldName: oldName, newName: newName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }

//    MARK: Navigation
    
    func presentAvc(indexPath: IndexPath) {
        isSharing.value = false
        guard let item = model[indexPath.item].publicUrl else { return }
        coordinator.presentAtivityVc(item: item)
        isSharing.value = false
    }
    
    func presentAvcFiles(path: URL, name: String) {
        networkManager.shareFile(with: path) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let response, let data)):
                do {
                    self.isSharing.value = true
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileExtension = (response.suggestedFilename as NSString?)?.pathExtension ?? path.pathExtension
                    let tempFileURL = tempDirectory.appendingPathComponent(name).appendingPathExtension(fileExtension)
                    try data.write(to: tempFileURL)
                    DispatchQueue.main.async {
                        self.isSharing.value = false
                        self.coordinator.presentAtivityVcFiles(item: tempFileURL)
                    }
                } catch {
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    func presentImage(model: CellDataModel) {
        coordinator.presentImageScene(model: model)
    }
    
    func paggination(title: String, path: inout String) {
        if path == "" {
            path = "disk:/"
        }
        coordinator.paggination(navigationTitle: title, path: path)
    }
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func numbersOfRowInSection() -> Int {
        return model.count
    }
    
    func logout() {
        keychain.delete(forKey: StrGlobalConstants.keycheinKey)
        coordinator.finish()
    }
}

//  MARK: CoreDataExtension

extension StorageViewModel {

    func FetchedResultsController() {
        let fetchRequest: NSFetchRequest<OfflineStorage> = OfflineStorage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let context = dataManager.persistentContainer.viewContext
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        
        try? fetchedResultController?.performFetch()
    }
    
    func numberOfRowInCoreDataSection() -> Int {
        guard let items = fetchedResultController?.fetchedObjects else { return 0 }
        return items.count
    }
    
    func returnItems(at indexPath: IndexPath) -> OfflineStorage? {
        return fetchedResultController?.object(at: indexPath)
    }
}
