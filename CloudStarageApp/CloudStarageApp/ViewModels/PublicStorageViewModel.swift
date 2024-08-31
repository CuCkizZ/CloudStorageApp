//
//  PublicStorageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation
import Network
import CoreData

protocol PublickStorageViewModelProtocol: BaseCollectionViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[CellDataModel]> { get set }
}

final class PublicStorageViewModel {
    
    private let coordinator: ProfileCoordinator
    private let keychain = KeychainManager.shared
    private let dataManager = CoreManager.shared
    private let networkMonitor = NWPathMonitor()
    var fetchedResultController: NSFetchedResultsController<OfflineItems>?

    private var model: [Item] = []
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var gettingUrl: (()->Void)?
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        startMonitoringNetwork()
        numberOfRowInCoreDataSection()
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}

extension PublicStorageViewModel: PublickStorageViewModelProtocol {
    
    func publishResource2(_ path: String, completion: @escaping (URL?) -> Void) {
        
    }
    
    
    func loadFile(from path: String, completion: @escaping (URL?) -> Void) {
        
    }
    
//    DataSource
    func numbersOfRowInSection() -> Int {
        model.count
    }
//    Network
    func publishResource(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
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
        NetworkManager.shared.fetchPublicData() { [weak self] result in
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
        NetworkManager.shared.deleteReqest(name: name)
    }
    
    
    func unpublishResource(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
    }
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        fetchData()
    }
    
    func createNewFolder(_ name: String) {
        if name.isEmpty == true {
            NetworkManager.shared.createNewFolder("New Folder")
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
    
    func presentAvc(item: String) {
        coordinator.presentAtivityVc(item: item)
    }
    
    func presentAvcFiles(path: URL) {
        NetworkManager.shared.shareFile(with: path) { result in
            switch result {
            case .success((let response, let data)):
                do {
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileExtension = (response.suggestedFilename as NSString?)?.pathExtension ?? path.pathExtension
                    let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension(fileExtension)
                    
                    try data.write(to: tempFileURL)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        coordinator.presentAtivityVcFiles(item: tempFileURL)
                    }
                } catch {
                    print ("viewModel error")
                }
            case .failure(_):
                break
            }
        }
    }
    
    func logout() {
        try? keychain.delete(forKey: "token")
        print("delted")
        coordinator.finish()
    }
}

//  MARK: CoreDataExtension

extension PublicStorageViewModel {

    func FetchedResultsController() {
        let fetchRequest: NSFetchRequest<OfflineItems> = OfflineItems.fetchRequest()
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
        let publishedNames = items.map { $0.publishedName }
        print(publishedNames.count)
        return publishedNames.count
    }
    
    func returnItems(at indexPath: IndexPath) -> OfflineItems? {
        return fetchedResultController?.object(at: indexPath)
    }
}

