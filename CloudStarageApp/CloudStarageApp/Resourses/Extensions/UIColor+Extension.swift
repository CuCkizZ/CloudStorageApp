//
//  UIColor+Extension.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt64) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
