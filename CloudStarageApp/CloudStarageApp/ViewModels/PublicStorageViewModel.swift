//
//  PublicStorageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation

protocol PublickStorageViewModelProtocol {
    
    var isLoading: Observable<Bool> { get set }
    var cellDataSource: Observable<[CellDataModel]> { get set }
    var searchKeyword: String { get set }
    var model: [PublicItem] { get set }
    
    
    func numbersOfRowInSection() -> Int
    func fetchData()
    func mapModel()
    func presentDetailVC(path: String)
    func sortData()
    func createNewFolder(_ name: String)
    func unpublicResource()
    func deleteFile(_ name: String)
}
    final class PublicStorageViewModel {
        private weak var coordinator: PublicCoordinator?
        var searchKeyword: String = ""
        
        var isLoading: Observable<Bool> = Observable(false)
        var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
        var model: [PublicItem] = []
        
        
        init(coordinator: PublicCoordinator) {
            self.coordinator = coordinator
            fetchData()
        }
        
        func mapModel() {
           // cellDataSource.value = model.compactMap { CellDataModel($0) }
        }

    }
extension PublicStorageViewModel: PublickStorageViewModelProtocol {
    
    
    func fetchData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchPublicData { [weak self] result in
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
    
    func unpublicResource() {
        
    }
    
    func numbersOfRowInSection() -> Int {
        5
    }
    
    func presentDetailVC(path: String) {
        
    }
    
    func sortData() {
        
    }
}
