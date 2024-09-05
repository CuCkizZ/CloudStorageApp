import UIKit
import SnapKit
import YandexLoginSDK

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModelProtocol
    private lazy var cellDataSource: [CellDataModel] = []

    var isOffline: Bool = false
    //   UI
    
    private lazy var selectedStyle: PresentationStyle = .table
    
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var uploadButton = CSUploadButton()
    private lazy var changeLayoutButton = CSChangeLayoutButton()
    private lazy var networkStatusView = UIView()
    private lazy var whileGettingLinkView = UIView(frame: view.bounds)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: IntConstants.DefaultHeight)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = IntConstants.minimumInteritemSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(FatalError.requiredInit)
    }
    
    //    MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindView()
        bindViewModel()
        bindNetworkMonitor()
        bindShareing()
    }
    
}
    
// MARK: BindingExtension

private extension HomeViewController {

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
                    self.collectionView.reloadData()
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
    
    func bindShareing() {
        viewModel.isSharing.bind { [weak self] isSharing in
            guard let self = self, let isSharing = isSharing else { return }
            DispatchQueue.main.async {
                if isSharing {
                    self.whileGettingLinkView.isHidden = false
                    self.activityIndicator.style = .medium
                    self.activityIndicator.startAnimating()
                } else {
                    self.whileGettingLinkView.isHidden = true
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
    }
    
    func setupView() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
        view.addSubview(changeLayoutButton)
        view.addSubview(whileGettingLinkView)
        view.backgroundColor = .white
        activityIndicator.hidesWhenStopped = true
        setupCollectionView()
        setupIsSharingView()
        setupLayoutButton()
    }
    
    func setupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        title = StrGlobalConstants.homeTitle
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
    
    func checkConnetction() {
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(showOfflineDeviceUI(notification:)),
                                               name: NSNotification.Name.connectivityStatus, 
                                               object: nil)
    }
    
    
    func setupIsSharingView() {
        whileGettingLinkView.isHidden = true
        whileGettingLinkView.backgroundColor = AppColors.customGray.withAlphaComponent(0.5)
        whileGettingLinkView.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(IntConstants.defaultPadding + 4)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(IntConstants.defaultPadding)
        }
        changeLayoutButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView).inset(IntConstants.defaultPadding / -2)
            make.right.equalTo(collectionView).inset(IntConstants.defaultPadding)
        }
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(IntConstants.defaultPadding)
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
            if layout.itemSize == CGSize(width: view.bounds.width, height: IntConstants.DefaultHeight) {
                layout.itemSize = IntConstants.itemSizeDefault
                selectedStyle = .table
                changeLayoutButton.setImage(selectedStyle.buttonImage, for: .normal)
            } else {
                layout.itemSize = CGSize(width: view.bounds.width, height: IntConstants.DefaultHeight)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isOffline {
        case true:
            errorConnection()
            return viewModel.numberOfRowInCoreDataSection()
        case false:
            return viewModel.numbersOfRowInSection()
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
            
            cell.offlineConfigure(items)
            
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch isOffline {
        case true:
            errorConnection()
        case false:
            let model = cellDataSource[indexPath.row]
            let name = model.name
            let fileType = model.file
            let mimeType = model.mimeType
            
            switch mimeType {
            case mimeType where mimeType.contains(FileTypes.word) || mimeType.contains(FileTypes.doc):
                viewModel.presentDocument(name: name, type: .web, fileType: fileType)
            case mimeType where mimeType.contains(FileTypes.pdf):
                viewModel.presentDocument(name: name, type: .pdf, fileType: fileType)
            case mimeType where mimeType.contains(FileTypes.image):
                viewModel.presentImage(model: model)
            default:
                break
            }
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, 
                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                        point: CGPoint) -> UIContextMenuConfiguration? {
        switch isOffline {
        case true:
            return UIContextMenuConfiguration()
        case false:
            guard let indexPath = indexPaths.first else { return nil }
            let model = cellDataSource[indexPath.row]
            return UIContextMenuConfiguration.contextMenuConfiguration(for: .last,
                                                                       viewModel: viewModel,
                                                                       model: model,
                                                                       indexPath: indexPath,
                                                                       viewController: self)
        }
    }
}

// MARK: Logout

extension HomeViewController {
    
    func setupLogout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .profileTab,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: StrGlobalConstants.logoutSheetTitle,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: StrGlobalConstants.cancleButton, style: .cancel, handler: { action in
            return
        }))
        alert.addAction(UIAlertAction(title: StrGlobalConstants.logoutTitle, style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            let confirmAlert = UIAlertController(title: StrGlobalConstants.logoutTitle,
                                                 message: StrGlobalConstants.AlertsAndActions.logOutAlertTitle,
                                                 preferredStyle: .alert)
            confirmAlert.addAction(UIAlertAction(title: StrGlobalConstants.yes, style: .default, handler: { action in
                self.viewModel.logout()
            }))
            confirmAlert.addAction(UIAlertAction(title: StrGlobalConstants.no, style: .destructive))
            present(confirmAlert, animated: true)
        }))
        present(alert, animated: true)
    }
}
