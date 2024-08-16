// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let embedded: Embedded
    let name: String?
    let exif: ExifClass?
    let resourceID: String?
    let created, modified: String?
    let path: String?
    let commentIDS: ExifClass?
    let type: String?
    let revision: Int?
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case name, exif, resourceID, created, modified, path
        case commentIDS, type, revision
        
    }
}
    
    
    // MARK: - Embedded
struct Embedded: Codable {
    let sort: String?
    let items: [Item]
    let limit, offset: Int?
    let path: String?
    let total: Int?
}
        
        
        // MARK: - Item
struct Item: Codable {
    let publicKey: String?
    let publicUrl: String?
    let name: String
    let exif: Exif
    let created: String
    let resourceID: String?
    let modified: String
    let path: String
    let type: String
    let revision: Int
    let antivirusStatus: String?
    let size: Int?
    let mimeType: String?
    let sizes: [Size]?
    let file: String?
    let mediaType: String?
    let preview: String?
    let sha256, md5: String?
}

    // MARK: - ExifClass
struct ExifClass: Codable {
}



// MARK: - ItemCommentIDS
struct ItemCommentIDS: Codable {
    let privateResource, publicResource: String
}

// MARK: - Exif
struct Exif: Codable {
    let dateTime: String?
}

// MARK: - Size
struct Size: Codable {
    let url: String?
    let name: String?
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct LastWelcome: Codable {
    let items: [LastItem]
    let limit: Int
}

// MARK: - Item
struct LastItem: Codable {
    let antivirusStatus: String
    let size: Int
    let name: String
    let exif: LastExif
    let created: String
    let resourceId: String
    let modified: String
    let mimeType: String
    let sizes: [LastSize]?
    let file: String
    let mediaType: String
    let preview: String?
    let path, sha256, type, md5: String
    let revision: Int
    let publicKey: String?
    let publicUrl: String?
    let photosliceTime: String?
}

// MARK: - CommentIDS
struct LastCommentIDS: Codable {
    let privateResource, publicResource: String?
}

// MARK: - Exif
struct LastExif: Codable {
    let dateTime: String?
}

// MARK: - Size
struct LastSize: Codable {
    let url: String?
    let name: String?
}

