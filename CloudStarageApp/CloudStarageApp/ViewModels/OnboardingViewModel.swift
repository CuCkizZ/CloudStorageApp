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
    
    weak var coordinator: OnboardingCoordinator?
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: OnboardingViewModelProtocol

extension OnboardingViewModel: OnboardingViewModelProtocol {
    func onbordingFinish() {
        coordinator?.finish()
    }
}
