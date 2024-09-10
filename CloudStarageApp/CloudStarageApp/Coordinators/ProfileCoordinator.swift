//
//  ProfileCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showProfileScene()
        
    }
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
    
extension ProfileCoordinator {
    
    func showProfileScene() {
        guard let navigationController = navigationController else { return }
        let profileVC = factory.makeProfileScene(coordinator: self)
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func goToPublic() {
        guard let navigationController = navigationController else { return }
        let publicVC = factory.makePublicScene(coordinator: self)
        navigationController.pushViewController(publicVC, animated: true)
    }
//    Not avalible now
//    func paggination(path: String, title: String) {
//        guard let navigationController = navigationController else { return }
//        let publicVC = factory.makePublicScene(navigationTitle: title, coordinator: self)
//        navigationController.pushViewController(publicVC, animated: true)
//    }
}
