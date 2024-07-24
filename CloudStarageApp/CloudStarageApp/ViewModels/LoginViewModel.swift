import Foundation

protocol LoginViewOutput: AnyObject {
    var isLoading: Observable<Bool> { get set }
    
    func login(login: String, password: String)
    func registration()
    func openHomeVC()
    func close()
}

final class LoginViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    
    private let coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    private func goToMainScreen() {
        coordinator.finish()
    }
    
}

extension LoginViewModel: LoginViewOutput {
    func login(login: String, password: String) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading.value = false
                self.goToMainScreen()
            }
        }
    }
    
//    TODO: корректировать вм
    
    func registration() {
        
    }
    
    func openHomeVC() {
        
    }
    
    func close() {
        
    }
}
