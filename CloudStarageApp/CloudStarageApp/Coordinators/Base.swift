//
//  Base.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

enum CoordinatorType {
    case app
    case onboarding
    case login
    case home
    case storage
    case profile
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var type: CoordinatorType { get }
    var navigationController: UINavigationController? { get set }
    var finishDelegate: CoorditatorFinishDelegate? { get set }
    
    func start()
    func finish()
}

extension CoordinatorProtocol {
    func addChildCoordinator(_ childCoordinator: CoordinatorProtocol) {
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter{ $0 !== childCoordinator }
    }
}

protocol CoorditatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol)
}

protocol TabBarCoordinatorProtocol: AnyObject, CoordinatorProtocol {
    var tabBarController: UITabBarController? { get set }
}

class Coorditator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol]
    var type: CoordinatorType
    var navigationController: UINavigationController?
    var finishDelegate: CoorditatorFinishDelegate?
    
    init(childCoordinators: [CoordinatorProtocol] = [CoordinatorProtocol](), type: CoordinatorType, navigationController: UINavigationController, finishDelegate: CoorditatorFinishDelegate? = nil) {
        self.childCoordinators = childCoordinators
        self.type = type
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    deinit {
        print("deinited \(type)")
        childCoordinators.forEach { $0.finishDelegate = nil }
        childCoordinators.removeAll()
    }
    
    func start() {
        print("Coordinator starts")
    }
    
    func finish() {
        print("Coordinator finished")
    }
    
    
}