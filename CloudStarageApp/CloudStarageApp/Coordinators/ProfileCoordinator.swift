//
//  ProfileCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class ProfileCoordinator: Coorditator {
    
    private let factory = SceneFactory.self
    
    override func start() {
       showProfileScene()
        
    }
    override func finish() {
        print("Im done")
    }
    
    func showProfileScene() {
        guard let navigationController = navigationController else { return }
        let loginVC = factory.makeProfileScene(coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }
}
