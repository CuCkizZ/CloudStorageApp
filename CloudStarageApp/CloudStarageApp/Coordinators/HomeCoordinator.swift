//
//  HomeCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    weak var appCoordinator: AppCoordinator? = nil
    
    override func start() {
        showHomeScene()
    }
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("Im done")
    }
    
    override func logoutFrom() {
        guard let navigationController = navigationController else { return }
        let coordinator: Coordinator = Coordinator(type: .app, navigationController: navigationController)
        coordinator.logoutFromHVC()
        finishDelegate?.coordinatorDidFinish(childCoordinator: coordinator)
    }
}

extension HomeCoordinator {
    
    func showHomeScene() {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeHomeScene(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func logout() {
        appCoordinator?.logout()
    }
    
}
