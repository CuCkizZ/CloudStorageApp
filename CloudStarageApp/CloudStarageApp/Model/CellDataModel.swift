import UIKit

struct Files {
    let name: String
    let size: String
    let date: String
    let icon: UIImage
}

struct MappedDataModel {
    static func get() -> [Files] {
        return [
            Files(name: "File 1", size: "2gb", date: "12.13.2022", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 2", size: "5gb", date: "12.13.2021", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 3", size: "4gb", date: "42.42.2022", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 4", size: "4gb", date: "51.12.2020", icon: #imageLiteral(resourceName: "file")),
            Files(name: "File 5", size: "5gb", date: "01.13.2013", icon: #imageLiteral(resourceName: "file"))
        ]
    }
}
