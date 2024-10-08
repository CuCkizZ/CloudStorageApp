
import UIKit

private enum LocalConstants {
        static let text1 = String(localized: "textOne", table: "OnboardingLocalizable")
        static let text2 = String(localized: "textTwo", table: "OnboardingLocalizable")
        static let text3 = String(localized: "textThree", table: "OnboardingLocalizable")
}

struct SceneFactory {
    
    //    MARK: OnboardingCoordinator
    
    static func makeOnbording(coordinaror: OnboardingCoordinator) -> OnboardingViewController {
        var pages = [OnboardingPageViewController]()
        
        let firstVC = OnboardingPageViewController()
        firstVC.configure(LocalConstants.text1, .image1)
        
        let secondVc = OnboardingPageViewController()
        secondVc.configure(LocalConstants.text2, .image2)
        
        let thirdVc = OnboardingPageViewController()
        thirdVc.configure(LocalConstants.text3, .image3)
        
        pages.append(firstVC)
        pages.append(secondVc)
        pages.append(thirdVc)
        
        let viewModel = OnboardingViewModel(coordinator: coordinaror)
        let view = OnboardingViewController(pages: pages, viewModel: viewModel)
        return view
    }
    
    //    MARK: AppCoordinator
    
    static func makeOnboardingFlow(coordinator: AppCoordinator,
                                   navigationController: UINavigationController,
                                   finisDelegate: CoorditatorFinishDelegate) {
        
        let onBoardingCoordinator = OnboardingCoordinator(type: .onboarding,
                                                          navigationController: navigationController,
                                                          finishDelegate: finisDelegate)
        coordinator.addChildCoordinator(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
    
    static func makeLoginFlow(coordinator: AppCoordinator,
                              navigationController: UINavigationController,
                              finisDelegate: CoorditatorFinishDelegate) -> LoginCoordinator {
        let loginCoordinator = LoginCoordinator(type: .login,
                                                navigationController: navigationController,
                                                finishDelegate: finisDelegate)
        coordinator.addChildCoordinator(loginCoordinator)
        return loginCoordinator
    }
    
    static func makePublicFlow(coordinator: AppCoordinator,
                               navigationController: UINavigationController,
                               finisDelegate: CoorditatorFinishDelegate) -> PublicCoordinator {
        let publicCoordinator = PublicCoordinator(type: .profile,
                                                  navigationController: navigationController,
                                                  finishDelegate: finisDelegate)
        coordinator.addChildCoordinator(publicCoordinator)
        return publicCoordinator
    }
    
    static func makeMainFlow(coordinator: AppCoordinator,
                             finishDelegate: CoorditatorFinishDelegate) -> TabBarController {
        
        let homeNavigationController = UINavigationController()
        let homeCoordinator: Coordinator = HomeCoordinator(type: .home, 
                                                           navigationController: homeNavigationController)
        homeNavigationController.tabBarItem = UITabBarItem(title: StrGlobalConstants.homeTitle,
                                                           image: UIImage(resource: .homeTab),
                                                           tag: 0)
        homeCoordinator.finishDelegate = finishDelegate
        homeCoordinator.start()
        
        let storageNavigationController = UINavigationController()
        let storageCoordinator: Coordinator = StorageCoordinator(type: .storage,
                                                                 navigationController: storageNavigationController)
        storageNavigationController.tabBarItem = UITabBarItem(title: StrGlobalConstants.storageTitle, 
                                                              image: UIImage(resource: .storageTab), 
                                                              tag: 1)
        storageCoordinator.finishDelegate = finishDelegate
        storageCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator: Coordinator = ProfileCoordinator(type: .profile,
                                                                 navigationController: profileNavigationController)
        profileNavigationController.tabBarItem = UITabBarItem(title: StrGlobalConstants.profileTitle, 
                                                              image: UIImage(resource: .profileTab),
                                                              tag: 2)
        profileCoordinator.finishDelegate = finishDelegate
        profileCoordinator.start()
        
        coordinator.addChildCoordinator(homeCoordinator)
        coordinator.addChildCoordinator(storageCoordinator)
        coordinator.addChildCoordinator(profileCoordinator)
        
        let tabBarControllers = [homeNavigationController, storageNavigationController, profileNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        return tabBarController
    }
    
    //    MARK: LoginCoordinator
    
    static func makeLoginScene(coordinator: LoginCoordinator) -> LoginViewController {
        let viewModel: LoginViewModelProtocol = LoginViewModel(coordinator: coordinator)
        let loginVC = LoginViewController(viewModel: viewModel)
        return loginVC
    }
    
    //    MARK: HomeCoordinator
    
    static func makeHomeScene(coordinator: HomeCoordinator) -> HomeViewController {
        let nm: NetworkManagerProtocol = NetworkManager()
        let vm: HomeViewModelProtocol = HomeViewModel(coordinator: coordinator, neworkManager: nm)
        let vc = HomeViewController(viewModel: vm)
        return vc
    }
    
    static func makeDocumentScene(name: String, type: TypeOfConfigDocumentVC, fileType: String, coordinator: Coordinator) -> DocumentViewController {
        let vm = DocumentViewModel(coordinator: coordinator, fileType: fileType)
        let vc = DocumentViewController(viewModel: vm)
        switch type {
        case .pdf:
            vc.configure(name: name, type: .pdf, fileType: fileType)
        case .web:
            vc.configure(name: name, type: .web, fileType: fileType)
        }
        return vc
    }
    
    static func makeImageScene(model: CellDataModel, coordinator: Coordinator) -> PresentImageViewController {
        let nm: NetworkManagerProtocol = NetworkManager()
        let vm = PresentImageViewModel(coordinator: coordinator, networkManager: nm)
        let vc = PresentImageViewController(viewModel: vm)
        vc.configure(model: model)
        return vc
    }
    
//    MARK: StorageCoordinator
    
    static func makeStorageScene(fetchpath: String, navigationTitle: String, coordinator: StorageCoordinator) -> StorageViewController {
        let nm: NetworkManagerProtocol = NetworkManager()
        let vm: StorageViewModelProtocol = StorageViewModel(coordinator: coordinator, networkManager: nm)
        let vc = StorageViewController(viewModel: vm, navigationTitle: navigationTitle, fetchpath: fetchpath)
        return vc
    }
    
    //    MARK: ProfileCoordinator
    
    static func makeProfileScene(coordinator: ProfileCoordinator) -> ProfileViewController {
        let nm: NetworkManagerProtocol = NetworkManager()
        let vm: ProfileViewModelProtocol = ProfileViewModel(coordinator: coordinator, networkManager: nm)
        let vc = ProfileViewController(viewModel: vm)
        return vc
    }
    
//    MARK: PublicStorageViewController
    
    static func makePublicScene(coordinator: ProfileCoordinator) -> PublicStorageViewController {
        let nm: NetworkManagerProtocol = NetworkManager()
        let vm: PublickStorageViewModelProtocol = PublicStorageViewModel(coordinator: coordinator, networkManager: nm)
        let vc = PublicStorageViewController(viewModel: vm)
        return vc
    }
    
    //    MARK: UIActivityViewController
    
    static func makeActivityVc(item: String, coordinator: Coordinator) -> UIActivityViewController {
        let avc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return avc
    }
    
    static func makeActivityVcWithFile(item: Any,  coordinator: Coordinator) -> UIActivityViewController {
        let avc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return avc
    }
    
}
