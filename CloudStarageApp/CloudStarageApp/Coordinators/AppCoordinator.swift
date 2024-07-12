//
//  AppCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

class AppCoordinator: Coorditator {
    
    private let userStorage = UserStorage.shared
    
    override func start() {
        if userStorage.skipOnboarding {
            
            showMainFlow()
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
        let onBoardingCoordinator = OnboardingCoordinator(type: .onboarding, 
                                                          navigationController: navigationController,
                                                          finishDelegate: self)
        addChildCoordinator(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
    
    func showMainFlow() {
        guard let navigationController = navigationController else { return }
        
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(type: .home, navigationController: homeNavigationController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), tag: 0)
        homeCoordinator.finishDelegate = self
        homeCoordinator.start()
        
        let storageNavigationController = UINavigationController()
        let storageCoordinator = StorageCoordinator(type: .storage, navigationController: storageNavigationController)
        storageNavigationController.tabBarItem = UITabBarItem(title: "Хранищиле", image: UIImage(systemName: "folder.fill"), tag: 1)
        storageCoordinator.finishDelegate = self
        storageCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(type: .profile, navigationController: profileNavigationController)
        profileNavigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.fill"), tag: 2)
        profileCoordinator.finishDelegate = self
        profileCoordinator.start()
        
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(storageCoordinator)
        addChildCoordinator(profileCoordinator)
        
        let tabBarControllers = [homeNavigationController, storageNavigationController, profileNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
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
