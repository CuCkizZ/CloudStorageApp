//
//  PagginationViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 07.08.2024.
//
import Foundation

protocol PagginationViewModelProtocol: AnyObject {
    var isLoading: Observable<Bool> { get set }
    var cellDataSource: Observable<[CellDataModel]> { get set }
    var searchKeyword: String { get set }
    var model: [Item] { get set }
    
    
    func numbersOfRowInSection() -> Int
    func fetchData(path: String)
    func pagination(_ path: String)
    func mapModel()
    func setTitle(_ name: String) -> String
    func presentDetailVC()
    func sortData()
    func createNewFolder(_ name: String)
    func deleteFile(_ name: String)
}

final class PagginationViewModel {
    
    private let coordinator: StorageCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[CellDataModel]> = Observable(nil)
    var model: [Item] = []
    
    
    init(coordinator: StorageCoordinator) {
        self.coordinator = coordinator
        //fetchData()
    }
    
    func mapModel() {
        cellDataSource.value = model.compactMap { CellDataModel($0) }
    }

    func returnPath() -> String {
        "dsa"
    }
    
}
    
extension PagginationViewModel: PagginationViewModelProtocol {
    
    func fetchData(path: String) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        NetworkManager.shared.fetchData(path) { [weak self] result in
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
                self.fetchData(path: name)
            }
    }
    
    func numbersOfRowInSection() -> Int {
        return model.count
    }
    
    func pagination(_ path: String) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
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
    
    func setTitle(_ name: String) -> String {
        name
    }
    
    func presentDetailVC() {
        //coordinator.paggination(name: "")
    }
    
    func sortData() {
        
    }
}
