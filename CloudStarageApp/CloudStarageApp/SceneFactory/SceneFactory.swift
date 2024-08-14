
import UIKit

private enum Constants {
    enum Onboarding {
        static let text1 = "Теперь все ваши документы в одном месте"
        static let text2 = "Доступ к файлам без интернета"
        static let text3 = "Делитесь вашими файлами с другими"
        static let image1 = "image1"
        static let image2 = "image2"
        static let image3 = "image3"
    }
}

//protocol SceneFactoryProtocol: AnyObject {
//    static func makeOnbording(coordinaror: OnboardingCoordinator) -> OnboardingViewController
//}

struct SceneFactory {
    
//    MARK: OnboardingCoordinator
    
    static func makeOnbording(coordinaror: OnboardingCoordinator) -> OnboardingViewController {
        var pages = [OnboardingPageViewController]()
        
        let firstVC = OnboardingPageViewController()
        firstVC.configure(Constants.Onboarding.text1, Constants.Onboarding.image1)
        
        let secondVc = OnboardingPageViewController()
        secondVc.configure(Constants.Onboarding.text2, Constants.Onboarding.image2)
        
        let thirdVc = OnboardingPageViewController()
        thirdVc.configure(Constants.Onboarding.text3, Constants.Onboarding.image3)
        
        pages.append(firstVC)
        pages.append(secondVc)
        pages.append(thirdVc)
        
        let viewModel = OnboardingViewModel(coordinator: coordinaror)
        let view = OnboardingViewController(pages: pages, viewModel: viewModel)
        return view
    }
    
//    //    MARK: AppCoordinator
    
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
    
    static func makeMainFlow(coordinator: AppCoordinator,
                             finishDelegate: CoorditatorFinishDelegate) -> TabBarController {
        
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(type: .home, navigationController: homeNavigationController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Latest", image: UIImage(resource: .homeTab), tag: 0)
        homeCoordinator.finishDelegate = finishDelegate
        homeCoordinator.start()
        
        let storageNavigationController = UINavigationController()
        let storageCoordinator = StorageCoordinator(type: .storage, navigationController: storageNavigationController)
        storageNavigationController.tabBarItem = UITabBarItem(title: "Storage", image: UIImage(resource: .storageTab), tag: 1)
        storageCoordinator.finishDelegate = finishDelegate
        storageCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(type: .profile, navigationController: profileNavigationController)
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(resource: .profileTab), tag: 2)
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
        let viewModel = LoginViewModel(coordinator: coordinator)
        let loginVC = LoginViewController(viewModel: viewModel)
        return loginVC
    }
    
//    MARK: HomeCoordinator
    
    static func makeHomeScene(coordinator: HomeCoordinator) -> HomeViewController {
        let viewModel = HomeViewModel(coordinator: coordinator)
        let homeVC = HomeViewController(viewModel: viewModel)
        return homeVC
    }
    
    static func makeDocumentScene(name: String, type: ConfigureTypes, fyleType: String, coordinator: HomeCoordinator) -> DocumentViewController {
        let vm = DocumentViewModel(coordinator: coordinator, fyleType: fyleType)
        let vc = DocumentViewController(viewModel: vm)
        switch type {
        case .pdf:
            vc.configure(name: name, type: .pdf, fileType: fyleType)
        case .web:
            vc.configure(name: name, type: .web, fileType: fyleType)
        }
        return vc
    }
    
    static func makeImageScene(url: URL, coordinator: Coordinator) -> PresentImageViewController {
        let vm = PresentImageViewModel(coordinator: coordinator)
        let vc = PresentImageViewController(viewModel: vm)
        vc.configure(url)
        return vc
    }
    
//    MARK: StorageCoordinator
    
    static func makeStorageScene(navigationTitle: String, coordinator: StorageCoordinator) -> StorageViewController {
        let vm = StorageViewModel(coordinator: coordinator)
        let vc = StorageViewController(viewModel: vm, navigationTitle: navigationTitle)
        return vc
    }
    
//    static func makePaggScene(name: String, coordinator: StorageCoordinator) -> PagginationViewController {
//        let vm = PagginationViewModel(coordinator: coordinator)
//        let vc = PagginationViewController(titleNav: name, viewModel: vm)
//        return vc
//    }
    
//    MARK: ProfileCoordinator
    
    static func makeProfileScene(coordinator: ProfileCoordinator) -> ProfileViewController {
        let viewModel = ProfileViewModel(coordinator: coordinator)
        let view = ProfileViewController(viewModel: viewModel)
        return view
    }
    
    static func makePublicScene(coordinator: ProfileCoordinator) -> PublicStorageViewController {
        let vm = PublicStorageViewModel(coordinator: coordinator)
        let vc = PublicStorageViewController(viewModel: vm)
        return vc
    }
    
    static func makeShareScene(coordinator: ProfileCoordinator) -> ShareActivityViewController {
        let vm = ShareActivityViewModel()
        let vc = ShareActivityViewController(viewModel: vm, shareLink: "")
        return vc
    }
    
//    MARK: ShareViewController
    static func makeShareSceneApp(shareLink: String, coordinator: Coordinator) -> ShareActivityViewController {
        let vm = ShareActivityViewModel()
        let vc = ShareActivityViewController(viewModel: vm, shareLink: shareLink)
        return vc
    }
}

