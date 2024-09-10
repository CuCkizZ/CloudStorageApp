import Foundation

struct ProfileDataSource: Decodable {
    let totalSpace: Int
    let usedSpace: Int
    let leftSpace: Int
}
