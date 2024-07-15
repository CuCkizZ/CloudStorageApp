//
//  UserStorage.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.07.2024.
//

import Foundation

final class UserStorage {
    
    static let shared = UserStorage()
    
    private init() {}
    
    var skipOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "skipOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "skipOnboarding") }
    }
    
}
