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
