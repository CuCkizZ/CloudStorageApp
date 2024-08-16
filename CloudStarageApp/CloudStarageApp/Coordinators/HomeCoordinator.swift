//
//  HomeCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showHomeScene()
    }
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("Im done")
    }
}

extension HomeCoordinator {
    
    func logout() {
    }
    
    func goToDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeDocumentScene(name: name, type: type, fileType: fileType, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showHomeScene() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeHomeScene(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentShareScene(shareLink: String) {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeShareSceneApp(shareLink: shareLink, coordinator: self)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                navigationController.view.bounds.height / 4
            })]
            navigationController.present(vc, animated: true)
        }
    }
    
    func presentAtivityVc(item: String) {
        guard let navigationController = navigationController else { return }
        let avc = factory.makeActivityVc(item: item, coordinator: self)
        navigationController.present(avc, animated: true)
    }
    
    func presentImageScene(url: URL)  {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeImageScene(url: url, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
