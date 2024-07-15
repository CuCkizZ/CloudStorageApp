//
//  AppCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

class AppCoordinator: Coorditator {
    
    private let userStorage = UserStorage.shared
    private let factory = SceneFactory.self
    
    override func start() {
    //    showOnboardingFlow()
//        if userStorage.skipOnboarding {
//            showMainFlow()
//        } else {
           showOnboardingFlow()
//        }
        
//        let loginVC = LoginViewController()
//        navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    override func finish() {
        print("Im done")
    }
}

// MARK: Navigation Methods
private extension AppCoordinator {
    func showOnboardingFlow() {
        guard let navigationController = navigationController else { return }
        factory.makeOnboardingFlow(coordinator: self,
                                   navigationController: navigationController,
                                   finisDelegate: self)
    }
    
    func showMainFlow() {
        guard let navigationController = navigationController else { return }
        let tabBarController = factory.makeMainFlow(coordinator: self, finishDelegate: self)
        navigationController.pushViewController(tabBarController, animated: true)
    }
}

extension AppCoordinator: CoorditatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .onboarding:
            navigationController?.viewControllers.removeAll()
            showMainFlow()
        case .app:
            return
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
