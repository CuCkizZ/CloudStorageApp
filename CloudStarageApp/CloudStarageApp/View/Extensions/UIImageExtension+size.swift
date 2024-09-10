//
//  UIImageExtension+size.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 06.09.2024.
//

import UIKit.UIImage

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
