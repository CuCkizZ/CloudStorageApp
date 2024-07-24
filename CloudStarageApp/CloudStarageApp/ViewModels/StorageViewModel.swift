import Foundation

protocol StorageViewModelProtocol: AnyObject {
    var isLoading: Observable<Bool> { get set }
    var searchKeyword: String { get set }
    var mapData: [Files] { get set }
    
    
    func numbersOfRowInSection() -> Int
    func fetchData()
    func presentDetailVC()
    func sortData()
}

final class StorageViewModel {
    
    private let coordinator: StorageCoordinator
    var searchKeyword: String = ""
    
    var isLoading: Observable<Bool> = Observable(false)
    private var cellDataSource: [Files] = MappedDataModel.get()
    var mapData: [Files] = []
    
    
    init(coordinator: StorageCoordinator) {
        self.coordinator = coordinator
    }
}
    
extension StorageViewModel: StorageViewModelProtocol {
    
    func numbersOfRowInSection() -> Int {
        return cellDataSource.count
       
    }
    
    func fetchData() {
    }
    
    func presentDetailVC() {
        coordinator.showStorageScene()
    }
    
    func sortData() {
        
    }
}

