import Foundation
import YandexLoginSDK

protocol LoginViewModelProtocol: AnyObject {
    var isLoading: Observable<Bool> { get set }
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
    
    var isLoading: Observable<Bool> = Observable(false)
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
        try? keychain.delete(forKey: "token")
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
        try? keychain.save(token, forKey: "token")
        print("token from viewmodel", token)
    }
    
    func login() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoading.value = false
                self.goToMainScreen()
            }
        }
    }
}
