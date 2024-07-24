//
//  OnboardingViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.07.2024.
//

import Foundation

protocol OnboardingViewModelProtocol: AnyObject {
    func onbordingFinish()
}

final class OnboardingViewModel {
    
    private let userStorage = UserStorage.shared
    weak var coordinator: OnboardingCoordinator?
    let model: [OnboardingModel] = []
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: OnboardingViewModelProtocol

extension OnboardingViewModel: OnboardingViewModelProtocol {
    func onbordingFinish() {
        coordinator?.finish()
        userStorage.skipOnboarding = true
    }
}
