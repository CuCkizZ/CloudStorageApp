//
//  ProfileViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation

protocol ProfileViewModelProtocol {
    func logOut()
}

final class ProfileViewModel {

    private let coordinator: ProfileCoordinator
//    TODO: Profile Model
//    private var [StorageData]
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
}

extension ProfileViewModel: ProfileViewModelProtocol {
    func logOut() {
        coordinator.finish()
    }
}
