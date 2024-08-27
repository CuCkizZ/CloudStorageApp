
import UIKit
import YandexLoginSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navBar = UINavigationController()
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = AppColors.standartBlue
                
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navBar
        window?.makeKeyAndVisible()
        
        let networl: NetworkServiceProtocol = NetworkService()
        networl.setToken()
        let appCoordinator = AppCoordinator(type: .app, navigationController: navBar, window: window)
        self.coordinator = appCoordinator
        appCoordinator.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for urlContext in URLContexts {
            let url = urlContext.url
            
            do {
                try YandexLoginSDK.shared.handleOpenURL(url)
            } catch {
                print("scene delegare error")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

