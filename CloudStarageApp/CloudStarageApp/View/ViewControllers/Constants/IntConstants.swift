//
//  Constants.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 28.08.2024.
//

import UIKit

enum FatalError {
    static let wrongCell = "Wrong cell"
    static let requiredInit = "init(coder:) has not been implemented"
}

extension UIViewController {
    
    enum IntConstants {
        static let defaultPadding = 16
        static let DefaultHeight: CGFloat = 38
        static let itemSizeDefault = CGSize(width: 100, height: 100)
        static let minimumLineSpacing: CGFloat = 5
        static let minimumInteritemSpacing: CGFloat = 5
    }
    
    enum StrConstants {
        static let defaultDirName =  String(localized: "New folder", table: "PublicConstantsLocalizable")
    }
    
    enum FileTypes {
        static let word = "word"
        static let pdf = "pdf"
        static let image = "image"
        static let video = "video"
        static let doc = "officedocument"
    }
}
