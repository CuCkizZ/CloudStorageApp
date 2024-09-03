//
//  OnboardingCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        setupOnboarding()
        
    }
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

private extension OnboardingCoordinator {
    
    func setupOnboarding() {
        let view = SceneFactory.makeOnbording(coordinaror: self)
        navigationController?.pushViewController(view, animated: true)
    }
}
