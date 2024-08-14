//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Foundation

protocol StorageViewModelProtocol: BaseViewModelProtocol, AnyObject {
    var cellDataSource: Observable<[CellDataModel]> { get set }
    
    func fetchCurrentData(navigationTitle: String, path: String)
    func presentVc(title: String, path: String)
    func presentShareScene(shareLink: String)
}

final class StorageViewModel {
    
    private let coordinator: StorageCoordinator
    private var model: [Item] = []
    
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    
    var path: String?
    
    
    init(coordinator: StorageCoordinator) {
        self.coordinator = coordinator
        //self.fetchData()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }

    func fetchdadada() {
    }
    
}
    
extension StorageViewModel: StorageViewModelProtocol {
    func presentAvc(item: String) {
        
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

    func presentVc(title: String, path: String) {
        coordinator.showStorageScene()
        //fetchCurrentData(title: title, path: path)
    }
    
    func presentShareScene(shareLink: String) {
        coordinator.presentShareScene(shareLink: shareLink)
    }
    
    func presentDocumet(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        coordinator.goToDocument(name: name, type: type, fileType: fileType)
    }
    
    func publishFile(_ path: String) {
        NetworkManager.shared.toPublicFile(path: path)
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
