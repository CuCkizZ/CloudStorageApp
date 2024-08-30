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
    var fetchedResultController: NSFetchedResultsController<OfflineItems>? { get set }

    var searchText: String { get set }
    func searchFiles()
    func logout()
    func setToken()
    
    func FetchedResultsController()
    func numberOfRowInCoreDataSection(section: Int) -> Int
    func returnItems(at indexPath: IndexPath) -> OfflineItems?
}

final class HomeViewModel {
    var onErrorReceived: ((String) -> Void)?
    private let coordinator: HomeCoordinator
    var loginResult: LoginResult? {
        didSet {
            
        }
    }
    private let keychain = KeychainManager.shared
    private let networkManager: NetworkServiceProtocol = NetworkService()
    private let dataManager = CoreManager.shared
    var fetchedResultController: NSFetchedResultsController<OfflineItems>?
    private var model: [Item] = []
    private let networkMonitor = NWPathMonitor()
    
    var isError: Observable<Bool> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(true)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var cellDataSourceOffline: Observable<[OfflineItems]> = Observable(nil)
    
    var gettingUrl: (()->Void)? 
    var searchText: String = ""
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        fetchData()
        startMonitoringNetwork()
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
        // self.saveToCoreData(items: cellDataSource.value ?? [])
    }
}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func numbersOfRowInSection() -> Int {
        model.count
    }
    
    func setToken() {
        //networkManager.getOAuthToken()
        //networkManager.setOAuthToken()
    }
    
    func loadFile(from path: String, completion: @escaping (URL?) -> Void) {
        let documentsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let path = documentsDirectory.appendingPathComponent(path)
        
        if FileManager.default.fileExists(atPath: "\(path)") {
            completion(path)
            print(path)
        } else {
            print("Файл не найден по пути: \(documentsDirectory)")
            completion(nil)
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
    
    //    MARK: Network
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchLastData { [weak self] result in
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
    
    func searchFiles() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.searchFile(keyword: searchText) { [weak self] result in
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
    
    func publishResource(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchData()
            //            Избавился от ошикбки, но не работает с первого раза
            self.gettingUrl?()
        }
    }
    
    func publishResource2(_ path: String, completion: @escaping (URL?) -> Void) {
        
    }
    
    func unpublishResource(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchData()
        }
    }
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchData()
        }
    }
    
    //    MARK: Navigation
    
    func presentShareView(shareLink: String) {
        //coordinator?.presentShareScene(shareLink: shareLink)
    }
    
    func presentAvc(item: String) {
        self.coordinator.presentAtivityVc(item: item)
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
                        self.coordinator.presentAtivityVcFiles(item: tempFileURL)
                    }
                } catch {
                    print ("viewModel error")
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
    
    func logout() {
        //  let token = keychain.get(forKey: "token")
        try? keychain.delete(forKey: "token")
        print("delted")
        let token = keychain.get(forKey: "token")
        if let loginResult = loginResult {
            let result = loginResult.token
            print("Login result = \(result)")
        }
        //        print("dwqdkskskskskkskksksk \(loginResult?.token)")
        //        print("""
        //_________________
        //                Token aftedelet \(token)
        //__________________
        //""")
        coordinator.finish()
    }
    
    //    MARK: CoreData
    
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

