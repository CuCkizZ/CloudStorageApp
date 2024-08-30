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
    
    var searchText: String { get set }
    func searchFiles()
    
    func fetchCurrentData(navigationTitle: String, path: String)
    func paggination(title: String, path: String)
}

final class StorageViewModel {
    
    private let coordinator: StorageCoordinator
    private let keychain = KeychainManager.shared
    private let dataManager = CoreManager.shared
    private var model: [Item] = []
    private let networkMonitor = NWPathMonitor()
    private var path: String?
    var searchText: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var fetchedResultController: NSFetchedResultsController<OfflineItems>?

    var gettingUrl: (()->Void)?
    
    init(coordinator: StorageCoordinator) {
        self.coordinator = coordinator
        startMonitoringNetwork()
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}
    
extension StorageViewModel: StorageViewModelProtocol {
    func publishResource2(_ path: String, completion: @escaping (URL?) -> Void) {
        
    }
    
    func loadFile(from path: String, completion: @escaping (URL?) -> Void) {
        
    }
    
    
    func presentShareView(shareLink: String) {
        
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
                    let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
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
    
    func presentImage(model: CellDataModel) {
        coordinator.presentImageScene(model: model)
    }
    
    func unpublishResource(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
    }
    
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchData() { [weak self] result in
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
    
    func fetchCurrentData(navigationTitle: String, path: String) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        //coordinator.paggination()
        NetworkManager.shared.fetchCurentData(path: path) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let file):
                    self.model = file
                    self.mapModel()
                    self.isLoading.value = false
                    print("\(path)")
                case .failure(let error):
                    print("model failrue: \(error)")
                }
            }
        }
    }
    
    
    func searchFiles() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        //coordinator.paggination()
        NetworkManager.shared.searchFile(keyword: searchText) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let file):
                    self.model = file
                    self.mapModel()
                    self.isLoading.value = false
                    print("\(self.searchText)")
                case .failure(let error):
                    print("model failrue: \(error)")
                }
            }
        }
    }
    
    func paggination(title: String, path: String) {
        coordinator.paggination(navigationTitle: title, path: path)
    }
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func publishResource(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
    }
    
    func deleteFile(_ name: String) {
        NetworkManager.shared.deleteReqest(name: name)
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
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        fetchData()
    }
    
    func numbersOfRowInSection() -> Int {
        return model.count
    }
    
    func logout() {
        try? keychain.delete(forKey: "token")
        print("delted")
        coordinator.finish()
    }
}

extension StorageViewModel {

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
    
    func numberOfRowInCoreDataSection(section: Int) -> Int {
        guard let section = fetchedResultController?.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func returnItems(at indexPath: IndexPath) -> OfflineItems? {
        return fetchedResultController?.object(at: indexPath)
    }
}
