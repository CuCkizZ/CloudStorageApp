import UIKit
import SnapKit

private let noDataText = String(localized: "You don't have any published files yet", table: "Messages+alertsLocalizable")

final class PublicStorageViewController: UIViewController {
    
    private let viewModel: PublickStorageViewModelProtocol
    private var cellDataSource: [CellDataModel] = []
    //    UI
    var isOffline: Bool = false
    
    private lazy var networkStatusView = UIView()
    private lazy var whileGettingLinkView = UIView(frame: view.bounds)
    private lazy var selectedStyle: PresentationStyle = .table
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var uploadButton = CSUploadButton()
    private lazy var changeLayoutButton = CSChangeLayoutButton()
    
    private lazy var noDataImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .noData)
        return imageView
    }()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = noDataText
        label.font = .Inter.light.size(of: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [noDataImage, noDataLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: Constants.DefaultHeight)
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
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
        bindView()
        bindViewModel()
        bindNetworkMonitor()
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
                stackView.isHidden = false
            } else {
                stackView.isHidden = true
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
        setupStackView()
        setupCollectionView()
        setupLogout()
        setupLayoutButton()
        uploadButtonPressed()
        setupStackView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
        view.addSubview(changeLayoutButton)
        view.addSubview(stackView)
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
    
    func modelReturn(indexPath: IndexPath) -> CellDataModel {
        return cellDataSource[indexPath.row]
    }
    
    func setupButtonUp() {
        uploadButton.action = { [weak self] in
            guard let self = self else { return }
            self.tap()
        }
    }
    
    func setupStackView() {
        stackView.isHidden = true
    }
    
    func uploadButtonPressed() {
        uploadButton.addAction(UIAction.createNewFolder(view: self,
                                                        viewModel: viewModel),
                               for: .touchUpInside)
    }
    
    func copyShare(share: URL) {
        UIPasteboard.general.url = share
    }
    
    func presentIt(shareLink: String) {
        let avc = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
        present(avc, animated: true)
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
            make.top.equalTo(collectionView).inset(-Constants.defaultPadding / 2)
            make.right.equalTo(collectionView).inset(Constants.defaultPadding)
        }
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaultPadding)
        }
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //   MARK: Objc Methods
    
    @objc func pullToRefresh() {
        viewModel.fetchData()
        refresher.endRefreshing()
    }
    
    @objc func tap() {
        uploadButtonPressed()
    }
    
    @objc private func changeContentLayout() {
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

//  MARK: CollectionViewDataSource + Delegate

extension PublicStorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelReturn(indexPath: indexPath)
        let name = model.name
        let mimeType = model.mimeType
        let fileType = model.file
        
        switch mimeType {
        case mimeType where mimeType.contains(Constants.FileTypes.word) || mimeType.contains(Constants.FileTypes.doc):
            viewModel.presentDocument(name: name, type: .web, fileType: fileType)
        case mimeType where mimeType.contains(Constants.FileTypes.pdf):
            viewModel.presentDocument(name: name, type: .pdf, fileType: fileType)
        case mimeType where mimeType.contains(Constants.FileTypes.image):
            viewModel.presentImage(model: model)
        case mimeType where mimeType.contains(Constants.FileTypes.video):
           print("video")
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let model = modelReturn(indexPath: indexPath)
        return UIContextMenuConfiguration.contextMenuConfiguration(for: .publish,
                                                                   viewModel: viewModel,
                                                                   model: model, indexPath: indexPath,
                                                                   viewController: self)
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
                    self.tabBarController?.tabBar.backgroundColor = .white

                }
            }
        }
    }
    
    func setupIsSharingView() {
        whileGettingLinkView.isHidden = true
        whileGettingLinkView.backgroundColor = AppColors.customGray.withAlphaComponent(0.5)
        whileGettingLinkView.addSubview(activityIndicator)
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
            
            cell.publishedOffline(items)
            
            return cell
        }
    }
}

extension PublicStorageViewController {
    func setupLogout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .profileTab, style: .plain, target: self, action: #selector(logoutTapped))
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
