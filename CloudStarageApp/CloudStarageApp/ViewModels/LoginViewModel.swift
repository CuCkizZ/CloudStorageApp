//
//  LoginViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 16.07.2024.
//

import Foundation

protocol LoginViewOutput: AnyObject {
    func login()
    func registration()
    func openHomeVC()
    func close()
}

final class LoginViewModel {
    
    private let coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
}

extension LoginViewModel: LoginViewOutput {
    func login() {
        
    }
    
    func registration() {
        
    }
    
    func openHomeVC() {
        
    }
    
    func close() {
        
    }
    
    
}
