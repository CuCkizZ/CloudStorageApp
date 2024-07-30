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
    func mapModel()
    func presentDetailVC()
    func sortData()
    func createNewFolder(_ name: String)
}

final class StorageViewModel {
    
    private let coordinator: StorageCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    internal var model: [Item] = []
    
    
    init(coordinator: StorageCoordinator) {
        self.coordinator = coordinator
        fetchData()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }

}
    
extension StorageViewModel: StorageViewModelProtocol {
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchData { [weak self] result in
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
    
    func createNewFolder(_ name: String) {
        NetworkManager.shared.createNewFolder(name)
    }
    
    func numbersOfRowInSection() -> Int {
        return model.count
    }
    
    func presentDetailVC() {
        //coordinator.showHomeScene()
    }
    
    func sortData() {
        
    }
}
