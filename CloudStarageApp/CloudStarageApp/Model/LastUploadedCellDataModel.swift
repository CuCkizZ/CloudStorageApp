//
//  CellLastDataModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 09.08.2024.
//

import Foundation

struct LastUploadedCellDataModel {
    let publickKey: String?
    let publicUrl: String?
    let name: String
    let date: String
    let type: String?
    let previewImage: String?
    let file: String
    let path: String
    let sizes: [LastSize]
    let size: Int?
    
    init(_ item: LastItem) {
        self.publickKey = item.publicKey
        self.publicUrl = item.publicURL 
        self.name = item.name
        self.date = dateFormatter(dateString: item.created)
        self.type = item.type
        self.previewImage = item.preview
        self.file = item.file
        self.path = item.path
        self.sizes = item.sizes
        self.size = item.size
        
        func dateFormatter(dateString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                return dateFormatter.string(from: date)
                
            }
            return ""
        }
    }
}
