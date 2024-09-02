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
    func logout()
    
}

final class HomeViewModel {
    var onErrorReceived: ((String) -> Void)?
    private let coordinator: HomeCoordinator
    var loginResult: LoginResult? {
        didSet {
            
        }
    }
    private let keychain = KeychainManager.shared
    private let dataManager = CoreManager.shared
    private let userStorage = UserStorage.shared
    private let networkService: NetworkServiceProtocol = NetworkService()
    var fetchedResultController: NSFetchedResultsController<OfflineItems>?
    private var model: [Item] = []
    private let networkMonitor = NWPathMonitor()
    
    var isError: Observable<Bool> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(true)
    var isSharing: Observable<Bool> = Observable(nil)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var cellDataSourceOffline: Observable<[OfflineItems]> = Observable(nil)
    
    var isPublished: (() -> IndexPath)?
    
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        fetchData()
        startMonitoringNetwork()
        YandexLoginSDK.shared.add(observer: self)
        
        guard let loginResult = loginResult else { return }
        didFinishLogin(with: Result<LoginResult, any Error>.success(loginResult))
        
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func getUrl(at indexPath: IndexPath) -> String? {
        return model[indexPath.row].publicUrl
    }
    
    func numbersOfRowInSection() -> Int {
        model.count
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
    
    func publishResource(_ path: String, indexPath: IndexPath) {
        NetworkManager.shared.toPublicFile(path: path)
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
    
    func presentAvc(indexPath: IndexPath) {
        guard let item = model[indexPath.row].publicUrl else { return }
        coordinator.presentAtivityVc(item: item)
        isSharing.value = false
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
    
    func chekLogin() {
//didFinishLogin(with: Result<LoginResult, any Error>)
    }
    
}
    
//    MARK: YandexLoginSDK

extension HomeViewModel: YandexLoginSDKObserver {
    
    func didFinishLogin(with result: Result<LoginResult, any Error>) {
        switch result {
        case .success(let loginResult):
            self.loginResult = loginResult
            networkService.getOAuthToken()
        case .failure(_):
            return
        }
    }
    
    func logout() {
        let tokenKey = "token"
        try? keychain.delete(forKey: tokenKey)
        try? YandexLoginSDK.shared.logout()
        userStorage.isLoginIn = false
        coordinator.finish()
    }
    
    //    MARK: CoreData
    
}

extension HomeViewModel {

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
        print(items.count)
        return items.count
    }
    
    func returnItems(at indexPath: IndexPath) -> OfflineItems? {
        return fetchedResultController?.object(at: indexPath)
    }
}

