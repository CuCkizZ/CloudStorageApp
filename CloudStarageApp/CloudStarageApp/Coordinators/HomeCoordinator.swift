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
    
    func goToPDF(fyleType: String) {
        guard let navigationController = navigationController else { return }
        let vc = factory.makePDFScene(fyleType: fyleType, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showHomeScene() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeHomeScene(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
