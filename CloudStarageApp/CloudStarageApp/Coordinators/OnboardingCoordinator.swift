//
//  OnboardingCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class OnboardingCoordinator: Coorditator {
    
    override func start() {
        setupOnboarding()
        
    }
    override func finish() {
        print("Im done")
    }
}

private extension OnboardingCoordinator {
    
    func setupOnboarding() {
        var pages = [UIViewController]()
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = .purple
        
        let secondVc = UIViewController()
        secondVc.view.backgroundColor = .yellow
        
        let thirdVc = UIViewController()
        thirdVc.view.backgroundColor = .green
        
        pages.append(firstVC)
        pages.append(secondVc)
        pages.append(thirdVc)
        
        let viewModel = OnboardingViewModel(coordinator: self)
        let view = OnboardingViewController(pages: pages, viewModel: viewModel)
        navigationController?.pushViewController(view, animated: true)
    }
    
}
