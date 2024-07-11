//
//  OnboardingCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class OnboardingCoordinator: Coorditator {
    
    override func start() {
        let vc = ViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func finish() {
        print("Im done")
    }
}
