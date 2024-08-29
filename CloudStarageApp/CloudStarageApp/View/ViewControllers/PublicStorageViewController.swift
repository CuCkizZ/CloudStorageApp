import UIKit
import SnapKit

final class PublicStorageViewController: UIViewController {
    
    private let viewModel: PublickStorageViewModelProtocol
    private var cellDataSource: [CellDataModel] = []
    private var navigationTitle: String
//    UI
    
    private lazy var networkStatusView = UIView()
    private lazy var selectedStyle: PresentationStyle = .table
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var uploadButton = CSUploadButton()
    private lazy var changeLayoutButton = CSChangeLayoutButton()
    
   private lazy var nothingLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing to show"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: Constants.DefaultHeight)
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    init(viewModel: PublickStorageViewModelProtocol, navigationTitle: String) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
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
    
    func bindView() {
        viewModel.cellDataSource.bind { [weak self] files in
            guard let self = self, let files = files else { return }
            self.cellDataSource = files
            collectionView.reloadData()
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
                } else {
                    self.showNetworkStatusView(self.networkStatusView)
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
        setupLable()
        setupLayoutButton()
        uploadButtonPressed()
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
    
    func SetupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationItem.rightBarButtonItem = navigationController.setRightButton()
        navigationItem.leftBarButtonItem = navigationController.setLeftButton()
        navigationController.navigationBar.prefersLargeTitles = true
        title = navigationTitle
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
    
    func setupLable() {
        //nothingLabel.isHidden = true
        if cellDataSource.isEmpty == true {
            nothingLabel.isHidden = false
            view.addSubview(nothingLabel)
        } else {
            nothingLabel.isHidden = true
        }
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
        nothingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //   MARK: Objc Methods
    
    @objc func pullToRefresh() {
        viewModel.fetchData()
        refresher.endRefreshing()
        setupLable()
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
                                                                   model: model,
                                                                   viewController: self)
    }
}

extension PublicStorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = modelReturn(indexPath: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID,
                                                            for: indexPath) as? CollectionViewCell else {
            fatalError(FatalError.wrongCell)
        }
        cell.configure(model)
        return cell
    }
}

extension PublicStorageViewController {
    func setupLogout() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .profileTab, style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
        viewModel.logout()
    }
}
