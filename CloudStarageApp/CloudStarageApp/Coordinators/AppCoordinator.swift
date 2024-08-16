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
       // showMainFlow()
        if userStorage.skipOnboarding {
            showAuthFlow()
        } else {
           showOnboardingFlow()
        }
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
    
    func showMainScene() {
        let tabBarController = factory.makeMainFlow(coordinator: self, finishDelegate: self)
        self.tabBarController = tabBarController
        let transition = CATransition()
//        TODO: create transition file
        transition.duration = 0.3
        transition.type = .reveal
        self.window?.layer.add(transition, forKey: kCATransition)
        self.window?.rootViewController = self.tabBarController
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
    
    func logout() {
        guard let navigationController = navigationController else { return }
        let homeCoordinator = HomeCoordinator(type: .home, navigationController: navigationController)
        homeCoordinator.finish()
        let storageCoordinator = StorageCoordinator(type: .storage, navigationController: navigationController)
        storageCoordinator.finish()
        let profileCoordinator = ProfileCoordinator(type: .profile, navigationController: navigationController)
        profileCoordinator.finish()
        
        let loginCoordinator = LoginCoordinator(type: .login, navigationController: navigationController)
        loginCoordinator.start()
        self.window?.rootViewController = navigationController
    }
}

extension AppCoordinator {
    
    func showMainFlow() {
        showMainScene()
    }
    
    func showPublicFlow() {
        showPublicScene()
    }
    
}

// MARK: CoorditatorFinishDelegate

extension AppCoordinator: CoorditatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .onboarding:
            //showMainFlow()
            showAuthFlow()
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .app:
            return
        case .login:
            showMainFlow()
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
        case .home:
            removeChildCoordinator(self)
        case .profile:
            logout()
            //showPublicFlow()
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
