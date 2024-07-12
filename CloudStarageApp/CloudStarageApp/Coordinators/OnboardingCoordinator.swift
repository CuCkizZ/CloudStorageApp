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
        var pages = [OnboardingPageViewController]()
        
        let firstVC = OnboardingPageViewController()
        firstVC.configure(Constants.Onboarding.text1, Constants.Onboarding.image1)
        
        let secondVc = OnboardingPageViewController()
        secondVc.configure(Constants.Onboarding.text2, Constants.Onboarding.image2)
    
        let thirdVc = OnboardingPageViewController()
        thirdVc.configure(Constants.Onboarding.text3, Constants.Onboarding.image3)
        
        pages.append(firstVC)
        pages.append(secondVc)
        pages.append(thirdVc)
        
        let viewModel = OnboardingViewModel(coordinator: self)
        let view = OnboardingViewController(pages: pages, viewModel: viewModel)
        navigationController?.pushViewController(view, animated: true)
    }
    
}
