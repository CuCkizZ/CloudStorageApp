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
        get { UserDefaults.standard.bool(forKey: Constants.skipOnbording) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.skipOnbording) }
    }
    
    var sortByName: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.sortByName)}
        set { UserDefaults.standard.set(newValue, forKey: Constants.sortByName)}
    }
}

private enum Constants {
    static let skipOnbording = "skipOnboarding"
    static let sortByName = "sortByName"
}
