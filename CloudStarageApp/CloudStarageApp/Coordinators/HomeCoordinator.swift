//
//  HomeCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class HomeCoordinator: Coorditator {
    
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
    
    func goToWeb() {
        
    }
    
    func showHomeScene() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeHomeScene(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
