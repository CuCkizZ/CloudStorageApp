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
    var mapData: [Files] { get set }
    
    
    func numbersOfRowInSection() -> Int
    func fetchData()
    func mapModel() 
    func presentDetailVC()
    func sortData()
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
//    private var model: [Files]?
    private var cellDataSource: [Files] = MappedDataModel.get()
    var mapData: [Files] = []
    
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        mapModel()
        
    }
//    
//    private func mapModel() {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.model = MapedDataModel.mapModel()
//            print(model?.count)
//            
//        }
    
    
    func mapModel() {
        mapData = cellDataSource.filter { $0.date.contains("2022") }
    }

}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func numbersOfRowInSection() -> Int {
        print(mapData.count)
        return mapData.count
       
    }
    
    func fetchData() {
    }
    
    func presentDetailVC() {
        coordinator.showHomeScene()
    }
    
    func sortData() {
        
    }
}
