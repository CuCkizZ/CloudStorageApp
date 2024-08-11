// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct PublicWelcome: Codable {
    let items: [PublicItem]
    let limit, offset: Int
}

// MARK: - Item
struct PublicItem: Codable {
    let antivirusStatus, publicKey: String?
    let publicUrl: String?
    let name: String
    let exif: Exif?
    let created: String
    let size: Int?
    let resourceID: String?
    let modified: String?
    let mimeType: String?
    let sizes: [Size]?
    let file: String?
    let mediaType: String?
    let preview: String?
    let path, type: String
    let revision: Int
}

