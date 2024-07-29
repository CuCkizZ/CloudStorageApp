import UIKit

struct CellDataModel {
    
    let name: String
//    let size: Int
//    let date: String
//    let previewImage: String
    
    init(_ item: Item) {
       
        self.name = item.name
//        self.size = item.size ?? 0
//        self.date = item.created
//        self.previewImage = item.preview ?? ""
    }
}
