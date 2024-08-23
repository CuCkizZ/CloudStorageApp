import UIKit
import SDWebImage

struct CellDataModel {
    let publickKey: String?
    let publicUrl: String?
    let name: String
    let date: String
    let type: String
    let previewImage: String?
    let file: String
    let path: String
    let sizes: [Size]
    let size: Int?
    let mimeType: String
    
    init(_ item: Item) {
        self.publickKey = item.publicKey
        self.publicUrl = item.publicUrl
        self.name = item.name
        self.date = dateFormatter(dateString: item.created)
        self.type = item.type
        self.previewImage = item.preview
        self.file = item.file ?? ""
        self.path = item.path
        self.sizes = item.sizes ?? []
        self.size = (item.size ?? 0) / (1024 * 1024)
        self.mimeType = item.mimeType ?? ""
        
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
