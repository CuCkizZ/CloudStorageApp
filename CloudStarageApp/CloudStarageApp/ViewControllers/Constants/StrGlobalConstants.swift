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
    static let defaultDirName =  String(localized: "New folder", table: "PublicConstantsLocalizable")
    static let yes = String(localized: "Yes", table: "PublicConstantsLocalizable")
    static let no = String(localized: "No", table: "PublicConstantsLocalizable")
    static let linkGettingError = String(localized: "Dont have a link, try again", table: "PublicConstantsLocalizable")
    static let logoutTitle = String(localized: "Log out", table: "PublicConstantsLocalizable")
    static let logoutSheetTitle = String(localized: "Profile", table: "PublicConstantsLocalizable")
    static let logoutMessage = String(localized: "Are you sure?", table: "PublicConstantsLocalizable")
    static let cancleButton = String(localized: "Cancle", table: "PublicConstantsLocalizable")
    
    enum AlertsAndActions {
        static let delete = String(localized: "Delete", table: "ContextMenuLocalizable")
        static let shareLink = String(localized: "Share a link", table: "ContextMenuLocalizable")
        static let shareFile = String(localized: "Share a file", table: "ContextMenuLocalizable")
        static let unpublish = String(localized: "Unpublish", table: "ContextMenuLocalizable")
        static let rename = String(localized: "Rename", table: "ContextMenuLocalizable")
        static let shareMenu = String(localized: "Share", table: "ContextMenuLocalizable")
        static let newName = String(localized: "New name", table: "ContextMenuLocalizable")
        static let enterTheName = String(localized: "Enter the name", table: "ContextMenuLocalizable")
        static let submit = String(localized: "Submite", table: "ContextMenuLocalizable")
        static let newFolderSheetTitle = String(localized: "Create new folder", table: "ContextMenuLocalizable")
        static let deleteConfirm = String(localized: "Are you sure delete ", table: "ContextMenuLocalizable")
        static let logOutAlertTitle = String(localized: "Do you really want to log out? All local data will be deleted",
                                             table: "ContextMenuLocalizable")
    }
    
    enum OfflineData {
        static let offlineProfile = "OfflineProfile"
        static let offlineItems = "OfflineItems"
        static let offlineStorage = "OfflineStorage"
        static let offlinePublished = "OfflinePublished"
    }
    
}
