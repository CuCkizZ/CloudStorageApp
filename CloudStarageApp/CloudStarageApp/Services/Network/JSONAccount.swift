
import Foundation

// MARK: - Welcome
struct Account: Codable {
    let maxFileSize: Int
    let paidMaxFileSize: Int
    let totalSpace: Int
    let regTime: String
    let trashSize: Int
    let isPaid: Bool
    let usedSpace: Int
    let systemFolders: SystemFolders
    let user: User
    let unlimitedAutouploadEnabled: Bool
    let revision: Int
}

// MARK: - SystemFolders
struct SystemFolders: Codable {
    let odnoklassniki, google, instagram, vkontakte: String
    let attach, mailru, downloads, applications: String
    let facebook, social, messenger, calendar: String
    let scans, screenshots, photostream: String
}

// MARK: - User
struct User: Codable {
    let regTime: String
    let displayName, uid, country: String
    let isChild: Bool
    let login: String
}

