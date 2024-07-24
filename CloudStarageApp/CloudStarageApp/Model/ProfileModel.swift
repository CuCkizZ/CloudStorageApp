//
//  ProfileModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 23.07.2024.
//

import Foundation

struct ProfileModel {
    let total: Float
    let usage: Float
    let left: Float
}

struct Profile {
    static func get() -> ProfileModel {
        ProfileModel(total: 20.0, usage: 15.0, left: 5.0)
    }
}
