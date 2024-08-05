//
//  PresentImageCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 01.08.2024.
//

import Foundation

final class PresentImageCoordinator: Coorditator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        presentImageScene()
        print("presentCoordinator starsts")
    }
    
    override func finish() {
        print("finish Login coordinator")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension PresentImageCoordinator {
    func presentImageScene() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makePresentScene(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
    