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
        print("Im done")
    }
}

extension StorageCoordinator {
    
    func showStorageScene() {
        guard let navigationController = navigationController else { return }
        let storageVC = factory.makeStorageScene(fetchpath: "disk:/", navigationTitle: "Storage", coordinator: self)
        navigationController.pushViewController(storageVC, animated: true)
    }
    
    func paggination(navigationTitle: String, path: String) {
        guard let navigationController = navigationController else { return }
        let pageVC = factory.makeStorageScene(fetchpath: path, navigationTitle: navigationTitle, coordinator: self)
        print("coordinator works")
        navigationController.pushViewController(pageVC, animated: true)
    }
    
//    func goToDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
//        guard let navigationController = navigationController else { return }
//        let vc = factory.makeDocumentScene(name: name, type: type, fileType: fileType, coordinator: self)
//        navigationController.pushViewController(vc, animated: true)
//    }
//    
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
//    
//    func presentImageScene(url: URL)  {
//        guard let navigationController = navigationController else { return }
//        let vc = factory.makeImageScene(url: url, coordinator: self)
//        navigationController.pushViewController(vc, animated: true)
//    }
    
}
