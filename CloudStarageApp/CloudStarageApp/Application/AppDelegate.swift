
import UIKit
import CoreData
import YandexLoginSDK

private let clientID = "e10974fe4b64489bac4eb6ab97efae3f"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            let clientID = clientID
            try YandexLoginSDK.shared.activate(with: clientID)
        } catch {
            print("1 application func error")
        }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
            return true
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        do {
            try YandexLoginSDK.shared.handleOpenURL(url)
        } catch {
            print("2 application func error")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        
        do {
            try YandexLoginSDK.shared.handleUserActivity(userActivity)
        } catch {
            print("3td application func error")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}
