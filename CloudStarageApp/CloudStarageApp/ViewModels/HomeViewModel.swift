//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import UIKit

protocol HomeViewModelProtocol: AnyObject {
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
    func deleteFile(_ name: String)
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    internal var model: [Item] = []
    
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        fetchData()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }

}
    
extension HomeViewModel: HomeViewModelProtocol {
    
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
    
    func deleteFile(_ name: String) {
        NetworkManager.shared.deleteReqest(name: name)
    }
    
    func createNewFolder(_ name: String) {
        NetworkManager.shared.createNewFolder(name)
    }
    
    func numbersOfRowInSection() -> Int {
        return model.count
    }
    
    func presentDetailVC() {
        coordinator.showHomeScene()
    }
    
    func sortData() {
        
    }
}
