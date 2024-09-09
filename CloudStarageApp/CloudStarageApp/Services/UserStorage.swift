//
//  UserStorage.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.07.2024.
//

import UIKit

final class UserStorage {
    
    static let shared = UserStorage()
    
    private init() {}
    
    var skipOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: UserConstants.skipOnbording) }
        set { UserDefaults.standard.set(newValue, forKey: UserConstants.skipOnbording) }
    }
    
    var isLoginIn: Bool {
        get { UserDefaults.standard.bool(forKey: UserConstants.isLoginIn) }
        set { UserDefaults.standard.setValue(newValue, forKey: UserConstants.isLoginIn) }
    }
    
    var sortByName: Bool {
        get { UserDefaults.standard.bool(forKey: UserConstants.sortByName)}
        set { UserDefaults.standard.set(newValue, forKey: UserConstants.sortByName)}
    }
}

private enum UserConstants {
    static let skipOnbording = "skipOnboarding"
    static let sortByName = "sortByName"
    static let isLoginIn = "isLogonIn"
}
