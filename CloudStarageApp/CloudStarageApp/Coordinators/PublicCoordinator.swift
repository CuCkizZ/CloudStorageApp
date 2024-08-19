//
//  PublicCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation

final class PublicCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        //showPublic()
        print("public coordinator started")
    }
    
    override func finish() {
        print("finish Login coordinator")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension PublicCoordinator {
    
//    func showPublic() {
//        guard let navigationController = navigationController else { return }
//        let vc = factory.makePublicScene(fetchpath: "disk:/", navigationTitle: "Published", coordinator: self)
//        navigationController.pushViewController(vc, animated: true)
//        print("public presented")
//    }
//    
//    func paggination(navigationTitle: String, path: String) {
//        guard let navigationController = navigationController else { return }
//        let pageVC = factory.makePublicScene(fetchpath: path, navigationTitle: navigationTitle, coordinator: self)
//        print("coordinator works")
//        navigationController.pushViewController(pageVC, animated: true)
//    }
}
