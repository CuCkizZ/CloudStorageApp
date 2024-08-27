import Foundation
import YandexLoginSDK

protocol LoginViewOutput: AnyObject {
    var isLoading: Observable<Bool> { get set }
    var loginResult: LoginResult? { get set }
    
    func login()
    func logout()
    func setToken()
    func saveToken(token: String)
}

final class LoginViewModel {
    
    private var client: NetworkServiceProtocol = NetworkService()
    private let userStorage = UserStorage.shared
    private var keychain: KeychainProtocol
    private let coordinator: LoginCoordinator
    
    var isLoading: Observable<Bool> = Observable(false)
    var onLoginStateChanged: ((Bool) -> Void)?
    var loginResult: LoginResult? {
        didSet {
            onLoginStateChanged?(loginResult != nil)
        }
    }
    
    
    init(coordinator: LoginCoordinator, keychain: KeychainProtocol) {
        self.coordinator = coordinator
        self.keychain = keychain
    }
    
    private func goToMainScreen() {
        coordinator.finish()
        userStorage.isLoginIn = true
    }
    
    private func cleareKeychain() {
        try? keychain.delete(forKey: "token")
    }
    
}

extension LoginViewModel: LoginViewOutput {
    
    func logout() {
        do {
            try YandexLoginSDK.shared.logout()
            loginResult = nil
            cleareKeychain()
        } catch {
            print("Logout error: \(error)")
        }
    }
    
    func saveToken(token: String) {
        let token = loginResult?.token ?? "no token"
        client.token = token
        print(token)
//        do {
//            try keychain.save(token, forKey: "token")
//        } catch {
//            print(error.localizedDescription, "Ошибка при сохранении")
//        }
//        setToken()
    }
    
    func setToken() {
        
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
                client.setToken()
                self.goToMainScreen()
            }
        }
    }
}
