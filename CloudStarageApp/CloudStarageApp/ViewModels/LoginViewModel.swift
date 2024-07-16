//
//  LoginViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 16.07.2024.
//

import Foundation

protocol LoginViewOutput: AnyObject {
    func login(login: String, password: String)
    func registration()
    func openHomeVC()
    func close()
}

final class LoginViewModel {
    
    private let coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    private func goToMainScreen() {
        coordinator.showMainScene()
    }
    
}

extension LoginViewModel: LoginViewOutput {
    func login(login: String, password: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.goToMainScreen()
            }
        }
    }
    
    func registration() {
        
    }
    
    func openHomeVC() {
        
    }
    
    func close() {
        
    }
    
    
}
