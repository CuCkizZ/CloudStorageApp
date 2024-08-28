//
//  AppCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let userStorage = UserStorage.shared
    private let factory = SceneFactory.self
    private var tabBarController = UITabBarController()
    
    override func start() {
//        if userStorage.isLoginIn {
//            showMainFlow()
         if userStorage.skipOnboarding {
            showAuthFlow()
        } else {
            showOnboardingFlow()
        }
    }
    
    override func finish() {
        logout()
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
    
    func showMainScene() {
        let tabBarController = factory.makeMainFlow(coordinator: self, finishDelegate: self)
        self.tabBarController = tabBarController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .reveal
        window?.layer.add(transition, forKey: kCATransition)
        window?.rootViewController = tabBarController
    }
    
    func showAuthFlow() {
        guard let navigationController = navigationController else { return }
        let loginCoordinator = factory.makeLoginFlow(coordinator: self,
                                                     navigationController: navigationController, finisDelegate: self)
        loginCoordinator.start()
    }
    
    func showPublicScene() {
        print("Attempting to show PublicViewController")
        guard let navigationController = navigationController else {
            print("Navigation controller is nil")
            return
        }
        let publicCoordinator = factory.makePublicFlow(coordinator: self,
                                                       navigationController: navigationController, finisDelegate: self)
        publicCoordinator.start()
    }
}

extension AppCoordinator {
    
    func showMainFlow() {
        showMainScene()
    }
    
    func showAuthScene() {
        showAuthFlow()
    }
    
    func showPublicFlow() {
        showPublicScene()
    }
    
    func logout() {
        for coordinator in childCoordinators {
            coordinator.finish()
        }
        childCoordinators.removeAll()
       
        tabBarController.viewControllers?.forEach { $0.removeFromParent() }
        tabBarController.view.removeFromSuperview()
        tabBarController.removeFromParent()

        navigationController?.viewControllers.forEach { $0.removeFromParent() }
        navigationController?.view.removeFromSuperview()
        navigationController = nil

        // userStorage.clearUserData()

        let authNavigationController = UINavigationController()
        
        let loginCoordinator = factory.makeLoginFlow(coordinator: self, navigationController: authNavigationController, finisDelegate: self)
        loginCoordinator.start()
        
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        window?.layer.add(transition, forKey: kCATransition)
        
        window?.rootViewController = authNavigationController
        window?.makeKeyAndVisible()

        print("User logged out, and authentication screen presented.")
    }
    
}

// MARK: CoorditatorFinishDelegate

extension AppCoordinator: CoorditatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .onboarding:
            showAuthFlow()
            removeChildCoordinator(self)
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .app:
            logout()
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .login:
            showMainFlow()
            removeChildCoordinator(self)
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .home:
            removeChildCoordinator(self)
        case .storage:
            removeChildCoordinator(self)
        case .profile:
            removeChildCoordinator(self)
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .publicCoordinator:
            showMainFlow()
        case .logout:
            showAuthFlow()
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
