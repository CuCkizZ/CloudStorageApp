//
//  HomeViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import UIKit

protocol HomeViewModelProtocol: AnyObject {
    var isLoading: Observable<Bool> { get set }
    var searchKeyword: String { get set }
    
    func numbersOfRowInSection() -> Int
    func fetchData()
    func presentDetailVC()
    func sortData()
}

final class HomeViewModel {
    
    private let coordinator: HomeCoordinator
    private let model = [Int]()
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    var celDataSource: [CellDataModel] = []
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        //self.mapModel()
    }
    
    func mapModel() {
        celDataSource.append(contentsOf: repeatElement(CellDataModel(name: "Наименование", size: "5 кб", date: "12.12.32 33:22", icon: UIImage(resource: .file)), count: 5))
    }
}
    
extension HomeViewModel: HomeViewModelProtocol {
    
    func numbersOfRowInSection() -> Int {
        celDataSource.count
    }
    
    func fetchData() {
        
    }
    
    func presentDetailVC() {
        
    }
    
    func sortData() {
        
    }
}
