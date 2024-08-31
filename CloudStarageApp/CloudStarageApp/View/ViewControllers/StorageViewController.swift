import UIKit
import SnapKit

final class StorageViewController: UIViewController {
    // MARK: Model
    private var viewModel: StorageViewModelProtocol
    private var cellDataSource: [CellDataModel] = []
    var searchController = UISearchController(searchResultsController: nil)
    var isOffline: Bool = false
    
    private var navigationTitle: String
    private var fetchPath: String
    //    UI
    
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var networkStatusView = UIView()
    private lazy var uploadButton = CSUploadButton()
    private lazy var changeLayoutButton = CSChangeLayoutButton()
    private lazy var selectedStyle: PresentationStyle = .table
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: Constants.DefaultHeight)
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    init(viewModel: StorageViewModelProtocol, navigationTitle: String, fetchpath: String) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        self.fetchPath = fetchpath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(FatalError.requiredInit)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarAfterPaggination()
        viewModel.fetchCurrentData(navigationTitle: navigationTitle, path: fetchPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindView()
        bindViewModel()
        bindNetworkMonitor()
    }
    
    func bindView() {
        viewModel.cellDataSource.bind { [weak self] files in
            guard let self = self, let files = files else { return }
            self.cellDataSource = files
            collectionView.reloadData()
        }
    }
    
    func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.collectionView.reloadData()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    func bindNetworkMonitor() {
        setupNetworkStatusView(networkStatusView)
        viewModel.isConnected.bind { [weak self] isConndeted in
            guard let self = self, let isConndeted = isConndeted else { return }
            DispatchQueue.main.async {
                if isConndeted {
                    self.hideNetworkStatusView(self.networkStatusView)
                    self.isOffline = false
                } else {
                    self.showNetworkStatusView(self.networkStatusView)
                    self.viewModel.FetchedResultsController()
                    self.isOffline = true
                }
            }
        }
    }
}

// MARK: Layout

private extension StorageViewController {
    
    func setupLayout() {
        setupView()
        setupNetworkStatusView(networkStatusView)
        setupButtonTap()
        uploadButtonPressed()
        setupLogout()
        setupLayoutButton()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
        view.addSubview(changeLayoutButton)
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    func setupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationItem.rightBarButtonItem = navigationController.setRightButton()
        navigationItem.searchController = searchController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.title = navigationTitle
        setupSearchController()
    }
    
    func setupNavBar2() {
        guard let navigationController = navigationController else { return }
        navigationItem.rightBarButtonItem = navigationController.setRightButton()
        navigationItem.searchController = searchController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.title = navigationTitle
        setupSearchController()
    }
    
    func setupNavBarAfterPaggination() {
        if fetchPath == "disk:/" {
            setupNavBar()
        } else {
            setupNavBar2()
        }
    }
    
    func setupLayoutButton() {
        changeLayoutButton.setImage(selectedStyle.buttonImage, for: .normal)
        changeLayoutButton.addTarget(self, action: #selector(changeContentLayout), for: .touchUpInside)
    }
    
    func changeLayoutAction() {
        changeLayoutButton.action = { [weak self] in
            guard let self = self else { return }
            self.changeContentLayout()
        }
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refresher
        refresher.tintColor = AppColors.customGray
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.addSubview(refresher)
    }
    
    func modelReturn(indexPath: IndexPath) -> CellDataModel {
        return cellDataSource[indexPath.row]
    }
    
    func setupButtonTap() {
        uploadButton.action = { [weak self] in
            guard let self = self else { return }
            self.tap()
        }
    }
    
    func tap() {
        uploadButtonPressed()
    }
    
    func uploadButtonPressed() {
        uploadButton.addAction(UIAction.createNewFolder(view: self,
                                                        viewModel: viewModel),
                               for: .touchUpInside)
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaultPadding - 4)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(Constants.defaultPadding)
            make.right.equalToSuperview()
        }
        changeLayoutButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView).inset(-Constants.defaultPadding / 2 )
            make.right.equalTo(collectionView).inset(Constants.defaultPadding)
        }
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaultPadding)
        }
    }
    
    //    MARK: @objc Methods
    
    @objc func pullToRefresh() {
        viewModel.fetchCurrentData(navigationTitle: navigationTitle, path: fetchPath)
        refresher.endRefreshing()
    }
    
    @objc func changeContentLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if layout.itemSize == CGSize(width: view.bounds.width, height: Constants.DefaultHeight) {
                layout.itemSize = Constants.itemSizeDefault
                navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "file")
            } else {
                layout.itemSize = CGSize(width: view.bounds.width, height: Constants.DefaultHeight)
                navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "profileTab")
            }
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension StorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelReturn(indexPath: indexPath)
        let name = model.name
        let path = model.path
        let fileType = model.file
        self.fetchPath = path
        
        let mimeType = model.mimeType
        
        switch mimeType {
        case mimeType where mimeType.contains(Constants.FileTypes.word) || mimeType.contains(Constants.FileTypes.doc):
            viewModel.presentDocument(name: name, type: .web, fileType: fileType)
        case mimeType where mimeType.contains(Constants.FileTypes.pdf):
            viewModel.presentDocument(name: name, type: .pdf, fileType: fileType)
        case mimeType where mimeType.contains(Constants.FileTypes.image):
            viewModel.presentImage(model: model)
        case fileType where fileType.contains(Constants.FileTypes.video):
            print("video")
        case "":
            viewModel.paggination(title: name, path: path)
            self.fetchPath = ""
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let model = modelReturn(indexPath: indexPath)
        return UIContextMenuConfiguration.contextMenuConfiguration(for: .full,
                                                                   viewModel: viewModel,
                                                                   model: model,
                                                                   viewController: self)
    }
}

extension StorageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isOffline {
        case true:
            viewModel.numberOfRowInCoreDataSection()
        case false:
            viewModel.numbersOfRowInSection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch isOffline {
        case false:
            let model = cellDataSource[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID,
                                                                for: indexPath) as? CollectionViewCell else {
                fatalError(FatalError.wrongCell)
            }
            
            cell.configure(model)
            
            return cell
        case true:
            guard let items = viewModel.returnItems(at: indexPath) else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID,
                                                                for: indexPath) as? CollectionViewCell else {
                fatalError(FatalError.wrongCell)
            }
            
            cell.offlineConfigure(config: .storage, items)
            
            return cell
        }
    }
}

extension StorageViewController: StorageViewControllerProtocol {
    func logout() {
        
    }
    
    func reloadCollectionView(collectionView: UICollectionView) {
        
    }
}

extension StorageViewController: UISearchBarDelegate, UISearchResultsUpdating  {
    
    @objc func setupSearchController() {
        searchController.searchBar.placeholder = "Введите запрос"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        if searchText != "" {
            viewModel.searchFiles()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
    }
}

extension StorageViewController {
    func setupLogout() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .profileTab, style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            return
        }))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            self.viewModel.logout()
        }))
        present(alert, animated: true)
    }
}
