//
//  UIFont+Extension.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

extension UIFont {
    enum Inter {
        enum regular {
            static func size(of size: CGFloat) -> UIFont {
                UIFont(name: Constants.Inter.regular, size: size)!
            }
        }
        enum bold {
            static func size(of size: CGFloat) -> UIFont {
                UIFont(name: Constants.Inter.bold, size: size)!
            }
        }
        enum light {
            static func size(of size: CGFloat) -> UIFont {
                UIFont(name: Constants.Inter.light, size: size)!
            }
        }
    }
}

private extension UIFont {
    enum Constants {
        enum Inter {
            static let black = "Inter-Black"
            static let bold = "Inter-Bold"
            static let extraBold = "Inter-ExtraBold"
            static let extraLight = "Inter-ExtraLight"
            static let light = "Inter-Light"
            static let medium = "Inter-Medium"
            static let regular = "Inter-Regular"
            static let semiBold = "Inter-SemiBold"
            static let thin = "Inter-Thin"
        }
    }
}
