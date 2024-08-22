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
        //goToPublic()
        //finishDelegate?.coordinatorDidFinish(childCoordinator: self)
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
        let publicVC = factory.makePublicScene(navigationTitle: "Published", coordinator: self)
        navigationController.pushViewController(publicVC, animated: true)
    }
    
    func paggination(path: String, title: String) {
        guard let navigationController = navigationController else { return }
        let publicVC = factory.makePublicScene(navigationTitle: title, coordinator: self)
        navigationController.pushViewController(publicVC, animated: true)
    }
    
//    func presentShareScene(shareLink: String) {
//        guard let navigationController = navigationController else { return }
//        let vc = factory.makeShareSceneApp(shareLink: shareLink, coordinator: self)
//        if let sheet = vc.sheetPresentationController {
//            sheet.detents = [.custom(resolver: { context in
//                navigationController.view.bounds.height / 4
//            })]
//            navigationController.present(vc, animated: true)
//        }
//    }
//    
//    func presentAtivityVc(item: String) {
//        guard let navigationController = navigationController else { return }
//        let avc = factory.makeActivityVc(item: item, coordinator: self)
//        navigationController.present(avc, animated: true)
//    }
    
    func Logout() {
        
    }
}
