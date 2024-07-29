//
//  ProfileViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation

protocol ProfileViewModelProtocol {
    var onDataLoaded: (() -> Void)? { get set }
    var dataSource: ProfileModel? { get set }
    var isLoading: Observable<Bool> { get set }
    func fetchData()
    func logOut()
}

final class ProfileViewModel {
    
    private let coordinator: ProfileCoordinator
    private var model: Account?
    var dataSource: ProfileModel?
    var isLoading: Observable<Bool> = Observable(false)
    var onDataLoaded: (() -> Void)?
 
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        fetchData()
    }
    
    func fetchData() {
        NetworkManager.shared.fetchAccountData { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.dataSource = profile
                    self.onDataLoaded?()
                case .failure(let error):
                    print("data viewmodel error: \(error)")
                }
                
            }
        }
    }
}

extension ProfileViewModel: ProfileViewModelProtocol {
    
    func logOut() {
        coordinator.finish()
    }
}
