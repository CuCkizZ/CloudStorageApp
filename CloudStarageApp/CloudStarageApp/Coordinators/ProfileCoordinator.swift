//
//  ProfileCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class ProfileCoordinator: Coorditator {
    
    private let factory = SceneFactory.self
    let log = LoginCoordinator.self
    
    override func start() {
       showProfileScene()
        
    }
    override func finish() {
        Logout()
        print("Im done")
    }
    
    func showProfileScene() {
        guard let navigationController = navigationController else { return }
        let profileVC = factory.makeProfileScene(coordinator: self)
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func Logout() {
       
    }
}
