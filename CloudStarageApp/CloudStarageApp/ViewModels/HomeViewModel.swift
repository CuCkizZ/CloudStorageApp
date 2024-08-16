//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Network
import Foundation

protocol HomeViewModelProtocol: BaseViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[LastUploadedCellDataModel]> { get set }
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String)
    func presentShareView(shareLink: String)
    func publishFile(_ path: String)
    
    func startMonitoringNetwork()
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[LastUploadedCellDataModel]> = Observable(nil)
    private var model: [LastItem] = []
    private let networkMonitor = NWPathMonitor()
    var isConnected: Observable<Bool> = Observable(true)
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        fetchData()
        startMonitoringNetwork()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { LastUploadedCellDataModel($0) }
    }
    

}
    
extension HomeViewModel: HomeViewModelProtocol {
    
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
        NetworkManager.shared.createNewFolder(name)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    func publishFile(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
    }
    
    func unpublishFile(_ path: String) {
        NetworkManager.shared.unpublishFile(path)
    }
    
    func renameFile(oldName: String, newName: String) {
        NetworkManager.shared.renameFile(oldName: oldName, newName: newName)
        fetchData()
    }
    
    func numbersOfRowInSection() -> Int {
        model.count
    }
    
    func presentShareView(shareLink: String) {
        coordinator.presentShareScene(shareLink: shareLink)
    }
    
    func presentAvc(item: String) {
        coordinator.presentAtivityVc(item: item)
    }
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.presentDocument(name: name, type: type, fileType: fileType)
    }
    
    func presentImage(url: URL) {
        coordinator.presentImageScene(url: url)
    }
    
}
