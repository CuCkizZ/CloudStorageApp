import Foundation
import YandexLoginSDK

protocol LoginViewModelProtocol: AnyObject {
    var loginResult: LoginResult? { get set }
    
    func login()
    func logout() 
    func saveToken(token: String)
}

final class LoginViewModel {
    
    private let client: NetworkServiceProtocol = NetworkService()
    private let userStorage = UserStorage.shared
    private let keychain = KeychainManager.shared
    private let coordinator: LoginCoordinator
    private weak var yandex: YandexLoginSDK?
    
    var onLoginStateChanged: ((Bool) -> Void)?
    var loginResult: LoginResult? {
        didSet {
            onLoginStateChanged?(loginResult != nil)
        }
    }
    
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    private func goToMainScreen() {
        coordinator.finish()
        userStorage.isLoginIn = true
    }
    
    private func cleareKeychain() {
        keychain.delete(forKey: PublickConstants.keycheinKey)
    }
    
}

extension LoginViewModel: LoginViewModelProtocol {
    
    func logout() {
        yandex = YandexLoginSDK.shared
        do {
            try yandex?.logout()
            loginResult = nil
            cleareKeychain()
            userStorage.isLoginIn = false
        } catch {
            print("Logout error: \(error)")
        }
    }
    
    func saveToken(token: String) {
        try? keychain.save(token, forKey: PublickConstants.keycheinKey)
    }
    
    func login() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.goToMainScreen()
        }
    }
}
