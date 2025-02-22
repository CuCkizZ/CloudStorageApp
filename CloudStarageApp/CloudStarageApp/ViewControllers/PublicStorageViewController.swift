import UIKit
import SnapKit

private let noDataText = String(localized: "You don't have any published files yet", table: "Messages+alertsLocalizable")

final class PublicStorageViewController: UIViewController {
    
    private let viewModel: PublickStorageViewModelProtocol
    private var cellDataSource: [CellDataModel] = []
    private var isOffline: Bool = false
    
    private lazy var networkStatusView = UIView()
    private lazy var whileGettingLinkView = GettinLinkView()
    private lazy var selectedStyle: PresentationStyle = .defaultGrid
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var uploadButton = CSUploadButton()
    private lazy var changeLayoutButton = CSChangeLayoutButton()
    private lazy var noDataView = NoDataView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: IntConstants.DefaultHeight)
        layout.minimumLineSpacing = IntConstants.minimumLineSpacing
        layout.minimumInteritemSpacing = IntConstants.minimumInteritemSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    init(viewModel: PublickStorageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(FatalError.requiredInit)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
        bindNetworkMonitor()
        bindView()
        bindShareing()
    }
}

// MARK: Bind Extension

private extension PublicStorageViewController {

    func bindView() {
        viewModel.cellDataSource.bind { [weak self] files in
            guard let self = self, let files = files else { return }
            self.cellDataSource = files
            collectionView.reloadData()
            if cellDataSource.count == 0 {
                noDataView.isHidden = false
            } else {
                noDataView.isHidden = true
            }
        }
    }
    
    func bindViewModel() {
        self.activityIndicator.isHidden = false
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
                    self.isOffline = true
                    self.viewModel.FetchedResultsController()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    func bindShareing() {
        viewModel.isSharing.bind { [weak self] isSharing in
            guard let self = self, let isSharing = isSharing else { return }
            DispatchQueue.main.async {
                if isSharing {
                    self.showGettingLinkView()
                    self.whileGettingLinkView.isHidden = false
                } else {
                    self.whileGettingLinkView.isHidden = true
                }
            }
        }
    }
}

// MARK: Layout

private extension PublicStorageViewController {
    
    func setupLayout() {
        setupView()
        SetupNavBar()
        setupNetworkStatusView(networkStatusView)
        setupButtonUp()
        setupCollectionView()
        setupLogout()
        setupLayoutButton()
        uploadButtonPressed()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(noDataView)
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
        view.addSubview(changeLayoutButton)
        view.backgroundColor = .white
    }
    
    func SetupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        title = StrGlobalConstants.publicTitle
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
    
    func setupButtonUp() {
        uploadButton.action = { [weak self] in
            guard let self = self else { return }
            self.tap()
        }
    }
    
    func uploadButtonPressed() {
        switch isOffline {
        case true:
            errorConnection()
        case false:
            uploadButton.addAction(UIAction.createNewFolder(view: self, viewModel: viewModel), for: .touchUpInside)
        }
    }
    
    func copyShare(share: URL) {
        UIPasteboard.general.url = share
    }
    
    func presentIt(shareLink: String) {
        let avc = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
        present(avc, animated: true)
    }
    
    
    func showGettingLinkView() {
        if #available(iOS 15.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(whileGettingLinkView)
                whileGettingLinkView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        } else {
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(whileGettingLinkView)
                whileGettingLinkView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(19)
        }
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(IntConstants.defaultPadding)
        }
        noDataView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
}

//  MARK: CollectionViewDataSource + Delegate

extension PublicStorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch isOffline {
        case true:
            errorConnection()
        case false:
            let model = cellDataSource[indexPath.item]
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
                UIAlertController.formatError(view: self)
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
            return UIContextMenuConfiguration.contextMenuConfiguration(for: .publish,
                                                                       viewModel: viewModel,
                                                                       model: model,
                                                                       indexPath: indexPath,
                                                                       viewController: self)
        }
    }
}

extension PublicStorageViewController: UICollectionViewDataSource {
    
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
            let model = cellDataSource[indexPath.item]
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
            
            cell.publishedOffline(items)
            
            return cell
        }
    }
}

extension PublicStorageViewController {
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
