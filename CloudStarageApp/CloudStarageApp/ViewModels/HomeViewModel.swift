//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Network
import Foundation
import YandexLoginSDK
import CoreData

protocol HomeViewModelProtocol: BaseCollectionViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[CellDataModel]> { get set }
    var cellDataSourceOffline: Observable<[OfflineItems]> { get set }
    func returnItems(at indexPath: IndexPath) -> OfflineItems?
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    private let neworkManager: NetworkManagerProtocol
    
    var loginResult: LoginResult? {
        didSet {
            
        }
    }
    
    private let keychain = KeychainManager.shared
    private let dataManager = CoreManager.shared
    private let userStorage = UserStorage.shared
    private var fetchedResultController: NSFetchedResultsController<OfflineItems>?
    private var model: [Item] = []
    private let networkMonitor = NWPathMonitor()
    
    var isError: Observable<Bool> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(true)
    var isSharing: Observable<Bool> = Observable(nil)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var cellDataSourceOffline: Observable<[OfflineItems]> = Observable(nil)
    
    init(coordinator: HomeCoordinator, neworkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.neworkManager = neworkManager
        startMonitoringNetwork()
        fetchData()
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func numbersOfRowInSection() -> Int {
        model.count
    }
    
    //    MARK: Network
    
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
        neworkManager.fetchLastData { [weak self] result in
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
    
    func deleteFile(_ name: String) {
        neworkManager.deleteReqest(name: name)
    }
    
    func createNewFolder(_ name: String) {
        if name.isEmpty == true {
            neworkManager.createNewFolder(StrGlobalConstants.defaultDirName)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.fetchData()
            }
        }
    }
    
    func publishResource(_ path: String, indexPath: IndexPath) {
        neworkManager.toPublicFile(path: path)
        isSharing.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
            if isSharing.value == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.presentAvc(indexPath: indexPath)
                    self.isSharing.value = false
                }
            }
        }
    }
    
    func unpublishResource(_ path: String) {
        neworkManager.unpublishFile(path)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchData()
        }
    }
    
    func renameFile(oldName: String, newName: String) {
        neworkManager.renameFile(oldName: oldName, newName: newName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchData()
        }
    }
    
    //    MARK: Navigation
    
    func presentAvc(indexPath: IndexPath) {
        guard let item = model[indexPath.row].publicUrl else { return }
        coordinator.presentAtivityVc(item: item)
        isSharing.value = false
    }
    
    func presentAvcFiles(path: URL, name: String) {
        neworkManager.shareFile(with: path) { [weak self] result in
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
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func presentImage(model: CellDataModel) {
        coordinator.presentImageScene(model: model)
    }
}
    
//    MARK: YandexLoginSDK

extension HomeViewModel {
    
    func logout() {
        try? YandexLoginSDK.shared.logout()
        coordinator.finish()
    }
}

//    MARK: CoreData

extension HomeViewModel {

    func FetchedResultsController() {
        let fetchRequest: NSFetchRequest<OfflineItems> = OfflineItems.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let context = dataManager.persistentContainer.viewContext
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        
        try? fetchedResultController?.performFetch()
    }
    
    func numberOfRowInCoreDataSection() -> Int {
        guard let items = fetchedResultController?.fetchedObjects else { return 0 }
        print(items.count)
        return items.count
    }
    
    func returnItems(at indexPath: IndexPath) -> OfflineItems? {
        return fetchedResultController?.object(at: indexPath)
    }
}

