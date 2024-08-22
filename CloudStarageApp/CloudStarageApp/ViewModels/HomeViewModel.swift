//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Network
import Foundation

protocol HomeViewModelProtocol: BaseCollectionViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[CellDataModel]> { get set }
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    private var model: [Item] = []
    private let networkMonitor = NWPathMonitor()
    
    var isLoading: Observable<Bool> = Observable(false)
    var isConnected: Observable<Bool> = Observable(true)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        fetchData()
        startMonitoringNetwork()
    }
    
    private func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }
}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func numbersOfRowInSection() -> Int {
        model.count
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
    
    func publishResource(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
        fetchData()
    }
    
    func unpublishResource(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
        fetchData()
    }
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        fetchData()
    }
    
//    MARK: Navigation
    
    func presentShareView(shareLink: String) {
        coordinator.presentShareScene(shareLink: shareLink)
    }
    
    func presentAvc(item: String) {
        coordinator.presentAtivityVc(item: item)
    }
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func presentImage(model: CellDataModel) {
        coordinator.presentImageScene(model: model)
    }
}
