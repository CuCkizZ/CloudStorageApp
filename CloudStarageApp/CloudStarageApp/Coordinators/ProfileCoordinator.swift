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
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("Profile done")
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
    
    func presentShare(from: UIViewController) {
        let shareVC = factory.makeShareScene(coordinator: self)
        if let sheet = shareVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                250
            })]
        }
        
        from.present(shareVC, animated: true)
    }
    
    func Logout() {
    }
}
