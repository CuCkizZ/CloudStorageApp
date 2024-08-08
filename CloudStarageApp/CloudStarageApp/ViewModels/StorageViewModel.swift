//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Foundation

protocol StorageViewModelProtocol: AnyObject {
    var isLoading: Observable<Bool> { get set }
    var cellDataSource: Observable<[CellDataModel]> { get set }
    var searchKeyword: String { get set }
    var model: [Item] { get set }
    
    
    func numbersOfRowInSection() -> Int
    func fetchData()
    func fetchCurrentData(name: String, path: String)
    func mapModel()
    func sortData()
    func createNewFolder(_ name: String)
    func deleteFile(_ name: String)
    func presentVc(path: String)
    func presentShareScene()
    func renameFile(oldName: String, newName: String)
}

final class StorageViewModel {
    
    private let coordinator: StorageCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var model: [Item] = []
    
    var path: String?
    
    
    init(coordinator: StorageCoordinator) {
        self.coordinator = coordinator
        self.fetchData()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }

    func returnPath() -> String {
        "dsa"
    }
    
}
    
extension StorageViewModel: StorageViewModelProtocol {
    
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
    
    func fetchCurrentData(name: String, path: String) {
        
//        if isLoading.value ?? true {
//            return
//        }
//        isLoading.value = true
//        //coordinator.paggination()
//        NetworkManager.shared.fetchCurentData(path: path) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let file):
//                    self.model = file
//                    self.mapModel()
//                    self.isLoading.value = false
//                    print("\(path)")
//                case .failure(let error):
//                    print("model failrue: \(error)")
//                }
//            }
//        }
    }
    
    func presentVc(path: String) {
        coordinator.showStorageScene()
        fetchCurrentData(name: "dsa", path: path)
    }
    
    func presentShareScene() {
        coordinator.presentShareScene()
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
