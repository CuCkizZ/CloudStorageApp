//
//  PresentImageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 01.08.2024.
//

import Foundation

protocol PresentImageViewModelProtocol {
    func popToRoot()
}

final class PresentImageViewModel {
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    
}

extension PresentImageViewModel: PresentImageViewModelProtocol {
    
    func popToRoot() {
        coordinator.popTo()
    }
}
