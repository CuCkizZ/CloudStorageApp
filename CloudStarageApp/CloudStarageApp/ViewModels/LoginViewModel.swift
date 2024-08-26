import Foundation
import YandexLoginSDK

protocol LoginViewOutput: AnyObject {
    var isLoading: Observable<Bool> { get set }
    var loginResult: LoginResult? { get set }
    
    func login()
    func logout()
    func openHomeVC()
    func close()
    func setToken()
}

final class LoginViewModel {
    
    private var client: NetworkServiceProtocol = NetworkService()
    
    var isLoading: Observable<Bool> = Observable(false)
    var onLoginStateChanged: ((Bool) -> Void)?
    var loginResult: LoginResult? {
        didSet {
            onLoginStateChanged?(loginResult != nil)
        }
    }
    
    private let coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    private func goToMainScreen() {
        coordinator.finish()
    }
    
}

extension LoginViewModel: LoginViewOutput {
    func openHomeVC() {
        
    }
    
    func logout() {
        do {
            try YandexLoginSDK.shared.logout()
            loginResult = nil
            KeychainManager.delete(forKey: "token")
        } catch {
            print("Logout error: \(error)")
        }
    }
    
    func setToken() {
        client.token = KeychainManager.retrieve(forKey: "token") ?? ""
        print(client.token)
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
    
//    TODO: корректировать вм
    
    func registration() {
        
    }
    
    func close() {
        
    }
}
