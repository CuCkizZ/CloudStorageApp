import UIKit

struct CellDataModel {
    
    let name: String
    //    let size: Int
    let date: String
    let type: String?
    let previewImage: String?
    let sizes: [Size]
    
    init(_ item: Item) {
        self.name = item.name
        //        self.size = item.size ?? 0
        self.date = item.created
        self.type = item.type
        self.previewImage = item.preview
        let sizes: [Size] = []
        self.sizes = sizes
    }
}
