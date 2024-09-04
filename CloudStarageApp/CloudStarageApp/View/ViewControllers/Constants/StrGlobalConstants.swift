//
//  PublickConstants.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 04.09.2024.
//

import Foundation

enum StrGlobalConstants {
    static let loginTitle = String(localized: "Welcome", table: "NavigationLocalizable")
    static let homeTitle = String(localized: "Latest", table: "NavigationLocalizable")
    static let storageTitle = String(localized: "All files", table: "NavigationLocalizable")
    static let publicTitle = String(localized: "Published files", table: "NavigationLocalizable")
    static let profileTitle = String(localized: "Profile", table: "NavigationLocalizable")
    
    static let keycheinKey = "token"
    static let linkGettingError = String(localized: "Dont have a link, try again", table: "PublicConstantsLocalizable")
    static let logoutTitle = String(localized: "Log out", table: "PublicConstantsLocalizable")
    static let logoutMessage = String(localized: "Are you sure?", table: "PublicConstantsLocalizable")
    static let cancleButton = String(localized: "Cancle", table: "PublicConstantsLocalizable")
}
