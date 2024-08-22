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
    case imagePresent
    case storage
    case profile
    case publicCoordinator
    case logout
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var type: CoordinatorType { get }
    var navigationController: UINavigationController? { get set }
    var finishDelegate: CoorditatorFinishDelegate? { get set }
    
    func start()
    func finish()
    func logouted()
}

extension CoordinatorProtocol {
    func addChildCoordinator(_ childCoordinator: CoordinatorProtocol) {
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
        print("filtred")
    }
}

protocol CoorditatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol)
}

protocol TabBarCoordinatorProtocol: AnyObject, CoordinatorProtocol {
    var tabBarController: UITabBarController? { get set }
}

class Coordinator: CoordinatorProtocol {
    
    private let factory = SceneFactory.self
    
    var childCoordinators: [CoordinatorProtocol]
    var type: CoordinatorType
    var navigationController: UINavigationController?
    var window: UIWindow?
    weak var finishDelegate: CoorditatorFinishDelegate?
    
    init(childCoordinators: [CoordinatorProtocol] = [CoordinatorProtocol](), type: CoordinatorType, navigationController: UINavigationController, window: UIWindow? = nil,  finishDelegate: CoorditatorFinishDelegate? = nil) {
        self.childCoordinators = childCoordinators
        self.type = type
        self.navigationController = navigationController
        self.window = window
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
    
    func logouted() {
        childCoordinators.forEach { $0.finish() }
        childCoordinators.removeAll()
    }
    
}
extension Coordinator {
    
    func presentDocument(name: String, type: TypeOfConfigDocumentVC, fileType: String) {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeDocumentScene(name: name, type: type, fileType: fileType, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentShareScene(shareLink: String) {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeShareSceneApp(shareLink: shareLink, coordinator: self)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                navigationController.view.bounds.height / 4
            })]
            navigationController.present(vc, animated: true)
        }
    }
    
    func presentAtivityVc(item: String) {
        guard let navigationController = navigationController else { return }
        let avc = factory.makeActivityVc(item: item, coordinator: self)
        navigationController.present(avc, animated: true)
    }
    
    func presentImageScene(model: CellDataModel)  {
        guard let navigationController = navigationController else { return }
        let vc = factory.makeImageScene(model: model, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popTo() {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
}
