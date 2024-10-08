//
//  PublicStorageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation
import Network
import CoreData
import YandexLoginSDK

protocol PublickStorageViewModelProtocol: BaseCollectionViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[CellDataModel]> { get set }
    func returnItems(at indexPath: IndexPath) -> OfflinePublished?
}

final class PublicStorageViewModel {
    
    private let coordinator: ProfileCoordinator
    private let networkManager: NetworkManagerProtocol
    private let keychain = KeychainManager.shared
    private let dataManager = CoreManager.shared
    private let networkMonitor = NWPathMonitor()
    private var fetchedResultController: NSFetchedResultsController<OfflinePublished>?
    private var model: [Item] = []
    
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    var isSharing: Observable<Bool> = Observable(nil)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    
    init(coordinator: ProfileCoordinator, networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
        startMonitoringNetwork()
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}

extension PublicStorageViewModel: PublickStorageViewModelProtocol {

    func numbersOfRowInSection() -> Int {
        model.count
    }
//    MARK: Network
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
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        networkManager.fetchPublicData() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.model = data
                    self.mapModel()
                    self.isLoading.value = false
                case .failure(let error):
                    print("model failrue: \(error)")
                }
            }
        }
    }
    
    func deleteFile(_ name: String) {
        networkManager.deleteReqest(name: name)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    
    func unpublishResource(_ path: String) {
        networkManager.unpublishFile(path)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func renameFile(oldName: String, newName: String) {
        networkManager.renameFile(oldName: oldName, newName: newName)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func createNewFolder(_ name: String) {
        if name.isEmpty == true {
            networkManager.createNewFolder(StrGlobalConstants.defaultDirName)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.fetchData()
            }
        }
    }
    
    func presentImage(model: CellDataModel) {
        coordinator.presentImageScene(model: model)
    }
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func presentAvc(indexPath: IndexPath) {
        isSharing.value = true
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
            case .failure(_):
                break
            }
        }
    }
    
    func logout() {
        try? YandexLoginSDK.shared.logout()
        coordinator.finish()
    }
}

//  MARK: CoreDataExtension

extension PublicStorageViewModel {

    func FetchedResultsController() {
        let fetchRequest: NSFetchRequest<OfflinePublished> = OfflinePublished.fetchRequest()
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
    
    func returnItems(at indexPath: IndexPath) -> OfflinePublished? {
        return fetchedResultController?.object(at: indexPath)
    }
}

