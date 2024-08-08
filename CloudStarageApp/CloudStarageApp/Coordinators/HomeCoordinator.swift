//
//  HomeCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showHomeScene()
    }
    override func finish() {
        print("Im done")
    }
}

extension HomeCoordinator {
    
    func goToDocument(type: ConfigureTypes, fyleType: String) {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeDocumentScene(type: type, fyleType: fyleType, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showHomeScene() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeHomeScene(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
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
