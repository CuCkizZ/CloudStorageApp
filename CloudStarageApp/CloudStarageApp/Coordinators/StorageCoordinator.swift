//
//  StorageCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class StorageCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showStorageScene()
    }
    
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension StorageCoordinator {
    
    func showStorageScene() {
        let title = StrGlobalConstants.storageTitle
        guard let navigationController = navigationController else { return }
        let storageVC = factory.makeStorageScene(fetchpath: "disk:/", navigationTitle: title, coordinator: self)
        navigationController.pushViewController(storageVC, animated: true)
    }
    
    func paggination(navigationTitle: String, path: String) {
        guard let navigationController = navigationController else { return }
        let pageVC = factory.makeStorageScene(fetchpath: path, navigationTitle: navigationTitle, coordinator: self)
        navigationController.pushViewController(pageVC, animated: true)
    }
}
