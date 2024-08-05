import UIKit
import SDWebImage

struct CellDataModel {
    
    let name: String
    //    let size: Int
    let date: String
    let type: String?
    let previewImage: String?
    let file: String
    let path: String
    let sizes: [Size]
    let size: Int?
    
    init(_ item: Item) {
        self.name = item.name
        //        self.size = item.size ?? 0
        self.date = item.created
        self.type = item.type
        self.previewImage = item.preview
        self.file = item.file ?? ""
        self.path = item.path
        self.sizes = item.sizes ?? []
        self.size = item.size
    }
}
