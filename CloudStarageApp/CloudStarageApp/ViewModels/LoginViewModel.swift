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
    private let keychain = KeychainManager.shared
    private let coordinator: LoginCoordinator
    
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
                self.goToMainScreen()
            }
        }
    }
}
