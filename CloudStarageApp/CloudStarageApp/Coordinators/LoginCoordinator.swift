//
//  LoginCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 16.07.2024.
//

import Foundation

final class LoginCoordinator: Coorditator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showAuthScene()
    }
    
    override func finish() {
        print("finish Login coordinator")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension LoginCoordinator {
    
    func showAuthScene() {
        guard let navigationController = navigationController else { return }
        let loginVC = factory.makeLoginScene(coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
}
