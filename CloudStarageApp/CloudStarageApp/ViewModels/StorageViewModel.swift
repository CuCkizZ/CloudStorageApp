//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Foundation
import Network

protocol StorageViewModelProtocol: BaseViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[CellDataModel]> { get set }
    
    func fetchCurrentData(navigationTitle: String, path: String)
    func paggination(title: String, path: String)
    func presentShareScene(shareLink: String)
}

final class StorageViewModel {
    
    private let coordinator: StorageCoordinator
    private var model: [Item] = []
    
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    private let networkMonitor = NWPathMonitor()
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    
    var path: String?
    
    
    init(coordinator: StorageCoordinator) {
        self.coordinator = coordinator
        //self.fetchData()
        startMonitoringNetwork()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }

    func fetchdadada() {
    }
    
}
    
extension StorageViewModel: StorageViewModelProtocol {
    
    
    func presentAvc(item: String) {
        coordinator.presentAtivityVc(item: item)
    }
    
    func presentImage(url: URL) {
        coordinator.presentImageScene(url: url)
    }
    
    
    func unpublishFile(_ path: String) {
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

    func paggination(title: String, path: String) {
        coordinator.paggination(navigationTitle: title, path: path)
        //fetchCurrentData(title: title, path: path)
    }
    
    func presentShareScene(shareLink: String) {
        coordinator.presentShareScene(shareLink: shareLink)
    }
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func publishFile(_ path: String) {
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
    
    
    func sortData() {
        
    }
}
