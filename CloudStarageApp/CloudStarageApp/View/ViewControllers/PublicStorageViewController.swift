import UIKit
import SnapKit

private enum PresentationStyle: String, CaseIterable {
    case table
    case defaultGrid
    
    var buttonImage: UIImage {
        switch self {
        case .table: return #imageLiteral(resourceName: "file")
        case .defaultGrid: return #imageLiteral(resourceName: "profileTab")
        }
    }
}

final class PublicStorageViewController: UIViewController {
    
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private let viewModel: PublickStorageViewModelProtocol
    private var cellDataSource: [PublicItem] = []
    
    private let nothingLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing to show"
        return label
    }()
    
    //MARK: CollectionView
    private lazy var uploadButton = CSUploadButton()
    private let changeLayoutButton = CSChangeLayoutButton()
    
    private var selectedStyle: PresentationStyle = .table
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 33)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    var navigationTitle: String
    private var fetchPath: String
    
    private let networkStatusView = UIView()
    
    init(viewModel: PublickStorageViewModelProtocol, navigationTitle: String, fetchpath: String) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        self.fetchPath = fetchpath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fetchPath == "" {
            fetchPath = "disk:/"
            viewModel.fetchData(path: fetchPath)
        }
        //viewModel.fetchCurrentData(navigationTitle: navigationTitle, path: fetchPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindNetworkMonitor()
        setupNetworkStatusView(networkStatusView)
        
        setupLayout()
        bindView()
        bindViewModel()
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
    
    private func modelReturn(indexPath: IndexPath) -> PublicItem {
        return cellDataSource[indexPath.row]
    }
    
    //   MARK: Objc Methods
    
    @objc func pullToRefresh() {
//        viewModel.fetchCurrentData(navigationTitle: navigationTitle, path: fetchPath)

        viewModel.fetchData(path: fetchPath)
        refresher.endRefreshing()
        setupLable()
    }
    
    @objc private func changeContentLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if layout.itemSize == CGSize(width: view.bounds.width, height: 33) {
                layout.itemSize = CGSize(width: 100, height: 100)
                navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "file")
            } else {
                layout.itemSize = CGSize(width: view.bounds.width, height: 33)
                navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "profileTab")
            }
            collectionView.collectionViewLayout.invalidateLayout()
        }
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
    
    @objc func tap() {
        uploadButtonPressed()
    }
    
    private func uploadButtonPressed() {
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
            make.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(16)
        }
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        nothingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension PublicStorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelReturn(indexPath: indexPath)
        let name = model.name
        let path = model.path
        self.fetchPath = path
        let mimeType = model.mimeType ?? "dir"
        
        switch mimeType {
        case mimeType where mimeType.contains("officedocument"):
            guard let filetype = model.file else { return }
            viewModel.presentDocument(name: name, type: .web, fileType: filetype)
        case mimeType where mimeType.contains("pdf"):
            guard let filetype = model.file else { return }
            viewModel.presentDocument(name: name, type: .pdf, fileType: filetype)
        case mimeType where mimeType.contains("image"):
            let urlString = model.sizes
            if let originalUrlString = urlString?.first(where: { $0.name == "ORIGINAL" })?.url {
                if let url = URL(string: originalUrlString) {
                    viewModel.presentImage(url: url)
                }
            }
        case mimeType where mimeType.contains("video"):
            viewModel.presentDetailVC(path: path)
        case "dir":
            viewModel.paggination(title: name, path: path)
        default:
            break
        }
        
        
        
        
//        if fileType.contains("officedocument") {
//            viewModel.presentDocument(name: name, type: .web, fileType: fileType)
//        } else if fileType.contains("image") {
//            let urlString = model.sizes
//            if let originalUrlString = urlString?.first(where: { $0.name == "ORIGINAL" })?.url {
//                if let url = URL(string: originalUrlString) {
//                    viewModel.presentImage(url: url)
//                }
//            }  else if fileType.contains("video") {
//                print("video")
//                //                } else if dir == "dir" {
//                //                    viewModel.paggination(title: name, path: path)
//                //                    self.fetchPath = ""
//            } else {
//                viewModel.presentDocument(name: name, type: .pdf, fileType: fileType)
//            }
//        }
//        print(fileType)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let model = modelReturn(indexPath: indexPath)
        let name = model.name
        let path = model.path
        let file = model.file
        let publicUrl = model.publicUrl
        let type = model.type
        return UIContextMenuConfiguration.contextMenuConfiguration(for: .publish, 
                                                                   viewModel: viewModel,
                                                                   name: name,
                                                                   path: path,
                                                                   file: file ?? "",
                                                                   publicUrl: publicUrl,
                                                                   type: type,
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
            fatalError("Wrong cell")
        }
        cell.publickConfigure(model)
        return cell
    }
}


