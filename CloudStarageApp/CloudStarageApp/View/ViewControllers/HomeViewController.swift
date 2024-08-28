import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModelProtocol
    private lazy var cellDataSource: [CellDataModel] = []
    
    //   UI
    
    private lazy var selectedStyle: PresentationStyle = .table
    var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var uploadButton = CSUploadButton()
    private lazy var changeLayoutButton = CSChangeLayoutButton()
    private lazy var networkStatusView = UIView()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 33)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setToken()
    }
    
    //    MARK: ViewDidLoad
    
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
}
    
// MARK: BindingExtension

private extension HomeViewController {

    
    func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                    //self.collectionView.reloadData()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    func bindNetworkMonitor() {
        self.setupNetworkStatusView(networkStatusView)
        viewModel.isConnected.bind { [weak self] isConndeted in
            guard let self = self, let isConndeted = isConndeted else { return }
            DispatchQueue.main.async {
                if isConndeted {
                    self.hideNetworkStatusView(self.networkStatusView)
                } else {
                    self.showNetworkStatusView(self.networkStatusView)
                }
            }
        }
    }
}

    // MARK: Layout
    
private extension HomeViewController {
    
    func setupLayout() {
        setupView()
        setupNetworkStatusView(networkStatusView)
        setupNavBar()
        setupUploadButton()
        uploadButtonPressed()
        
        setupLogout()
        
        setupConstraints()
        setupLayoutButton()
    }
    
    func setupView() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
        view.addSubview(changeLayoutButton)
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        activityIndicator.hidesWhenStopped = true
        setupCollectionView()
        setupSearchController()
    }
    
    func setupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationItem.rightBarButtonItem = navigationController.setRightButton()
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem?.action = #selector((setupSearchController))
        navigationController.navigationBar.prefersLargeTitles = true
        title = "Latests"
    }
    
    func modelReturn(indexPath: IndexPath) -> CellDataModel {
        return cellDataSource[indexPath.row]
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
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collectionView.refreshControl = refresher
        collectionView.alwaysBounceVertical = true
        refresher.tintColor = AppColors.customGray
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.addSubview(refresher)
    }
    
    func setupUploadButton() {
        uploadButton.action = { [weak self] in
            guard let self = self else { return }
            self.tap()
        }
    }
    
    func uploadButtonPressed() {
        uploadButton.addAction(UIAction.createNewFolder(view: self,
                                                        viewModel: viewModel),
                               for: .touchUpInside)
    }
    
    func chechPublickKey(publicKey: String?) -> Bool {
        if publicKey != nil {
            return true
        } else {
            return false
        }
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
        }
        changeLayoutButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView).inset(-32)
            make.right.equalTo(collectionView).inset(16)
        }
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    //   MARK: Objc Methods
    
    @objc func pullToRefresh() {
        viewModel.fetchData()
        collectionView.reloadData()
        refresher.endRefreshing()
    }
    
    @objc func tap() {
        uploadButtonPressed()
    }
    
    @objc func changeContentLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if layout.itemSize == CGSize(width: view.bounds.width, height: 33) {
                layout.itemSize = CGSize(width: 100, height: 100)
                selectedStyle = .table
                changeLayoutButton.setImage(selectedStyle.buttonImage, for: .normal)
            } else {
                layout.itemSize = CGSize(width: view.bounds.width, height: 33)
                selectedStyle = .defaultGrid
                changeLayoutButton.setImage(selectedStyle.buttonImage, for: .normal)
            }
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            print("Connected")
        } else {
            print("Not connected")
        }
    }
}

//    MARK: CollectionViewDataSource + Delegate

extension HomeViewController: UICollectionViewDataSource {
    
//    TODO: PubksheIconSharedAnimation
    
//    func shareButtonTapped(for indexPath: IndexPath) {
//        let model = modelReturn(indexPath: indexPath)
//        if model.publicUrl?.isEmpty == false {
//            updateCell(at: indexPath)
//        }
//    }
//    
//    func updateCell(at indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
//        let model = modelReturn(indexPath: indexPath)
//        cell.configure(model)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = modelReturn(indexPath: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID,
                                                            for: indexPath) as? CollectionViewCell else {
            fatalError("Wrong cell")
        }
        cell.configure(model)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelReturn(indexPath: indexPath)
        let name = model.name
        let fileType = model.file
        let mimeType = model.mimeType
        
        switch mimeType {
        case mimeType where mimeType.contains("word") || mimeType.contains("officedocument"):
            viewModel.presentDocument(name: name, type: .web, fileType: fileType)
        case mimeType where mimeType.contains("pdf"):
            viewModel.presentDocument(name: name, type: .pdf, fileType: fileType)
        case mimeType where mimeType.contains("image"):
            viewModel.presentImage(model: model)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let model = modelReturn(indexPath: indexPath)
        return UIContextMenuConfiguration.contextMenuConfiguration(for: .last,
                                                                   viewModel: viewModel,
                                                                   model: model,
                                                                   viewController: self)
    }
}


extension HomeViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
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

// MARK: Logout

extension HomeViewController {
    func setupLogout() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .profileTab, style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
        viewModel.logout()
    }
}
