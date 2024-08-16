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
        showPublic()
        print("public coordinator started")
    }
    
    override func finish() {
        print("finish Login coordinator")
        //finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension PublicCoordinator {
    
    func showPublic() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makePublicScene(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
        print("public presented")
    }
    
//    func presentAtivityVc(item: String) {
//        guard let navigationController = navigationController else { return }
//        let avc = factory.makeActivityVc(item: item, coordinator: self)
//        navigationController.present(avc, animated: true)
//    }
    
}
