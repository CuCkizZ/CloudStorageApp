//
//  PublicStorageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation
import Network

protocol PublickStorageViewModelProtocol: BaseViewModelProtocol, AnyObject {
    
    var isLoading: Observable<Bool> { get set }
    var cellDataSource: Observable<[CellDataModel]> { get set }

    func presentDetailVC(path: String)
    func unpublicResource(path: String)
    func presentShareView(shareLink: String)
    func paggination(title: String, path: String)
    func fetchData(path: String)
    
}
final class PublicStorageViewModel {
    private var coordinator: ProfileCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(nil)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    private let networkMonitor = NWPathMonitor()
    var model: [Item] = []
    
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        startMonitoringNetwork()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}

extension PublicStorageViewModel: PublickStorageViewModelProtocol {
    func presentAvc(item: String) {
        
    }
    
    func presentImage(model: CellDataModel) {
        coordinator.presentImageScene(model: model)
    }
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func publishFile(_ path: String) {
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
    
    func fetchData() {}
    
    func fetchData(path: String) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchPublicData(path: path) { [weak self] result in
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
    
    func createNewFolder(_ name: String) {
        NetworkManager.shared.createNewFolder(name)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func paggination(title: String, path: String) {
        coordinator.paggination(path: path, title: title)
        //fetchCurrentData(title: title, path: path)
    }
    
    func unpublicResource(path: String) {
        NetworkManager.shared.unpublishFile(path)
    }
    
    func numbersOfRowInSection() -> Int {
        model.count
    }
    
    func presentDetailVC(path: String) {
        
    }
    
    func presentShareView(shareLink: String) {
        //coordinator.presentShareScene(shareLink: shareLink)
    }
    
    func unpublishFile(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
    }
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        fetchData()
    }
    
    func sortData() {
        
    }
}
