//
//  LogoutCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 27.08.2024.
//

import Foundation

final class LogoutCoordinator: Coordinator {
    private let factory = SceneFactory.self
    
    override func start() {
        
    }
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("Im done")
    }
}

extension LogoutCoordinator {
    
    func logoutS() {
        guard let navigationController = navigationController else { return }
        let loginCoordinator = LoginCoordinator(type: .logout, navigationController: navigationController)
        let vc = factory.makeLoginScene(coordinator: loginCoordinator)
        navigationController.pushViewController(vc, animated: true)
    }
}
