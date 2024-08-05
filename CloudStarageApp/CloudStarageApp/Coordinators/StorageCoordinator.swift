//
//  StorageCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class StorageCoordinator: Coorditator {
    
    
    private let factory = SceneFactory.self
    
    override func start() {
        showStorageScene()
    }
    override func finish() {
        print("Im done")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension StorageCoordinator {
    
    func showStorageScene() {
        guard let navigationController = navigationController else { return }
        let loginVC = factory.makeStorageScene(coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }
}
