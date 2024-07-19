//
//  ProfileViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import Foundation

protocol ProfileViewModelProtocol {
    
}

final class ProfileViewModel {

    private let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
}

extension ProfileViewModel: ProfileViewModelProtocol {
    
}
