//
//  DetailCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import Foundation

final class DetailCoordinator: Coorditator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showDetailScene()
    }
    override func finish() {
        print("Im done")
    }
}

extension DetailCoordinator {
    
    func showDetailScene() {
        guard let navigationController = navigationController else { return }
        let loginVC = factory.makeDetailScene(coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }
}
