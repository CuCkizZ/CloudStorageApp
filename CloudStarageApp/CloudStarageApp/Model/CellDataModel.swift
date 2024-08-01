import UIKit

struct CellDataModel {
    
    let name: String
//    let size: Int
    let date: String
    let previewImage: URL?
    
    init(_ item: Item) {
       
        self.name = item.name
//        self.size = item.size ?? 0
        self.date = item.created
        self.previewImage = item.preview.flatMap { URL(string: $0) } }
}
