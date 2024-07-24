//
//  LastHomeModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import UIKit

struct Files {
    let name: String
    let size: String
    let date: String
    let icon: UIImage
}

struct MappedDataModel {
    static func get() -> [Files] {
        return [
            Files(name: "File 1", size: "2gb", date: "12.13.13", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 2", size: "5gb", date: "12.13.13", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 3", size: "4gb", date: "42.42.13", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 4", size: "4gb", date: "51.12.13", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 5", size: "5gb", date: "01.13.13", icon: #imageLiteral(resourceName: "file"))
        ]
    }
}
