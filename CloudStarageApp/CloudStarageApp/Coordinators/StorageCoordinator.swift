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
        print("Im done")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension StorageCoordinator {
    
    func showStorageScene() {
        guard let navigationController = navigationController else { return }
        let storageVC = factory.makeStorageScene(titleName: "", coordinator: self)
        navigationController.pushViewController(storageVC, animated: true)
    }
    
    func paggination(name: String) {
        guard let navigationController = navigationController else { return }
        let pageVC = factory.makeStorageScene(titleName: name, coordinator: self)
        print("coordinator works")
        navigationController.pushViewController(pageVC, animated: true)
    }
    
    func presentShareScene() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeShareSceneApp(coordinator: self)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                navigationController.view.bounds.height / 4
            })]
            navigationController.present(vc, animated: true)
        }
    }
    
}
