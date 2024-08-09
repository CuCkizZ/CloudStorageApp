//import XCTest
//@testable import CloudStarageApp
//
//class HomeViewModelTests: XCTestCase {
//    var viewModel: HomeViewModel!
//    var coordinator: MockHomeCoordinator!
//
//    override func setUp() {
//        super.setUp()
//        coordinator = MockHomeCoordinator(type: .home, navigationController: UINavigationController())
//        viewModel = HomeViewModel(coordinator: coordinator)
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        coordinator = nil
//        super.tearDown()
//    }
//
//    func testFetchData() {
//        let expectation = XCTestExpectation(description: "Fetch data")
//
//        viewModel.fetchData()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            XCTAssertFalse(self.viewModel.isLoading.value ?? true)
//            XCTAssertNotNil(self.viewModel.cellDataSource.value)
//            XCTAssertEqual(self.viewModel.model.count, self.viewModel.cellDataSource.value?.count)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 2)
//    }
//
//    func testDeleteFile() {
//        let name = "test.txt"
//        viewModel.deleteFile(name)
//        // Add assertions to verify that the delete request was sent correctly
//    }
//
//    func testCreateNewFolder() {
//        let name = "new_folder"
//        viewModel.createNewFolder(name)
//        // Add assertions to verify that the create new folder request was sent correctly
//    }
//
//    func testPublicFile() {
//        let path = "/path/to/file.txt"
//        viewModel.publicFile(path)
//        // Add assertions to verify that the public file request was sent correctly
//    }
//
//    func testRenameFile() {
//        let oldName = "old_file.txt"
//        let newName = "new_file.txt"
//        viewModel.renameFile(oldName: oldName, newName: newName)
//        // Add assertions to verify that the rename file request was sent correctly
//    }
//
//    func testNumbersOfRowInSection() {
//        let count = viewModel.numbersOfRowInSection()
//        XCTAssertEqual(count, viewModel.model.count)
//    }
//}
//
//class MockHomeCoordinator: HomeCoordinator {
//    var presentShareSceneCalled = false
//    var goToDocumentCalled = false
//    var goToDocumentType: ConfigureTypes?
//    var goToDocumentFileType: String?
//}
