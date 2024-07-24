//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import UIKit

protocol HomeViewModelProtocol: AnyObject {
    var isLoading: Observable<Bool> { get set }
//    var cellDataSource: Observable<[Files]> { get set }
    var searchKeyword: String { get set }
    
    func numbersOfRowInSection() -> Int
    func fetchData()
    func presentDetailVC()
    func sortData()
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
//    private var model: [Files]?
    var cellDataSource: [Files] = MappedDataModel.get()
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
//    
//    private func mapModel() {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.model = MapedDataModel.mapModel()
//            print(model?.count)
//            
//        }
    
    
//    func mapModel() {
//        cellDataSource.append(contentsOf: repeatElement(CellDataModel(name: "Наименование", size: "5 кб", date: "12.12.32 33:22", icon: UIImage(resource: .file)), count: 5))
//    }
    
//    func mapModel() -> [Files] {
//        cellDataSource = MappedDataModel.get()
//    }
}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func numbersOfRowInSection() -> Int {
        return cellDataSource.count
    }
    
    func fetchData() {
        
    }
    
    func presentDetailVC() {
        coordinator.showHomeScene()
    }
    
    func sortData() {
        
    }
}
