
import UIKit

private enum Constants {
    enum Onboarding {
        static let text1 = "Теперь все ваши документы в одном месте"
        static let text2 = "Доступ к файлам без интернета"
        static let text3 = "Делитесь вашими файлами с другими"
    }
}

struct SceneFactory {
    
    //    MARK: OnboardingCoordinator
    
    static func makeOnbording(coordinaror: OnboardingCoordinator) -> OnboardingViewController {
        var pages = [OnboardingPageViewController]()
        
        let firstVC = OnboardingPageViewController()
        firstVC.configure(Constants.Onboarding.text1, .image1)
        
        let secondVc = OnboardingPageViewController()
        secondVc.configure(Constants.Onboarding.text2, .image2)
        
        let thirdVc = OnboardingPageViewController()
        thirdVc.configure(Constants.Onboarding.text3, .image3)
        
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
        let homeCoordinator: Coordinator = HomeCoordinator(type: .home, navigationController: homeNavigationController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Latest", image: UIImage(resource: .homeTab), tag: 0)
        homeCoordinator.finishDelegate = finishDelegate
        homeCoordinator.start()
        
        let storageNavigationController = UINavigationController()
        let storageCoordinator: Coordinator = StorageCoordinator(type: .storage, navigationController: storageNavigationController)
        storageNavigationController.tabBarItem = UITabBarItem(title: "Storage", image: UIImage(resource: .storageTab), tag: 1)
        storageCoordinator.finishDelegate = finishDelegate
        storageCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator: Coordinator = ProfileCoordinator(type: .profile, navigationController: profileNavigationController)
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
        let viewModel: LoginViewOutput = LoginViewModel(coordinator: coordinator)
        let loginVC = LoginViewController(viewModel: viewModel)
        return loginVC
    }
    
    //    MARK: HomeCoordinator
    
    static func makeHomeScene(coordinator: HomeCoordinator) -> HomeViewController {
        let vm: HomeViewModelProtocol = HomeViewModel(coordinator: coordinator)
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
        let vm = PresentImageViewModel(coordinator: coordinator)
        let vc = PresentImageViewController(viewModel: vm)
        vc.configure(model: model)
        return vc
    }
    
//    MARK: StorageCoordinator
    
    static func makeStorageScene(fetchpath: String, navigationTitle: String, coordinator: StorageCoordinator) -> StorageViewController {
        let vm: StorageViewModelProtocol = StorageViewModel(coordinator: coordinator)
        let vc = StorageViewController(viewModel: vm, navigationTitle: navigationTitle, fetchpath: fetchpath)
        return vc
    }
    
    //    MARK: ProfileCoordinator
    
    static func makeProfileScene(coordinator: ProfileCoordinator) -> ProfileViewController {
        let vm: ProfileViewModelProtocol = ProfileViewModel(coordinator: coordinator)
        let vc = ProfileViewController(viewModel: vm)
        return vc
    }
    
    static func makePublicScene(navigationTitle: String, coordinator: ProfileCoordinator) -> PublicStorageViewController {
        let vm: PublickStorageViewModelProtocol = PublicStorageViewModel(coordinator: coordinator)
        let vc = PublicStorageViewController(viewModel: vm, navigationTitle: navigationTitle)
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
    
    static func makeActivityVc(item: String, coordinator: Coordinator) -> UIActivityViewController {
        let avc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return avc
    }
    
    static func makeActivityVcWithFile(item: Any,  coordinator: Coordinator) -> UIActivityViewController {
        let avc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return avc
    }
    
}
