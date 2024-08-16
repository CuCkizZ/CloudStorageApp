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

final class StorageViewController: UIViewController {
    // MARK: Model
    private var viewModel: StorageViewModelProtocol
    private var cellDataSource: [CellDataModel] = []
    
    private lazy var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var uploadButton = CSUploadButton()
    private lazy var changeLayoutButton = CSChangeLayoutButton()
    private lazy var selectedStyle: PresentationStyle = .table
    var navigationTitle: String
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 33)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
   

    init(viewModel: StorageViewModelProtocol, navigationTitle: String) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

// MARK: Layout

private extension StorageViewController {
    
    func setupLayout() {
        setupView()
        SetupNavBar()
        setupButtonTap()
        uploadButtonPressed()
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
    
    func SetupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationItem.rightBarButtonItem = navigationController.setRightButton()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.title = navigationTitle
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
        collectionView.refreshControl = refresher
        collectionView.alwaysBounceVertical = true
        refresher.tintColor = AppColors.customGray
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.addSubview(refresher)
    }
    
    private func modelReturn(indexPath: IndexPath) -> CellDataModel {
        return cellDataSource[indexPath.row]
    }
    
    @objc func pullToRefresh() {
        viewModel.fetchData()
        refresher.endRefreshing()
    }
    
    @objc func changeContentLayout() {
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
    
    func setupButtonTap() {
        uploadButton.action = { [weak self] in
            guard let self = self else { return }
            self.tap()
        }
    }
    
    func tap() {
        uploadButtonPressed()
    }
    
    private func uploadButtonPressed() {
        uploadButton.addAction(UIAction.createNewFolder(view: self,
                                                        viewModel: viewModel),
                               for: .touchUpInside)
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(16)
        }
        changeLayoutButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView).inset(-32)
            make.right.equalTo(collectionView).inset(16)
        }
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func presentByTap(type: TypeOfConfigDocumentVC) {
        let name = ""
        let fileType = ""
        switch type {
        case .pdf, .web:
            viewModel.presentDocumet(name: name, type: .web, fileType: fileType)
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
        
        if fileType.contains("officedocument") {
            viewModel.presentDocumet(name: name, type: .web, fileType: fileType)
        } else if fileType.contains("image") {
            let urlString = cellDataSource[indexPath.row].sizes
            if let originalUrlString = urlString.first(where: { $0.name == "ORIGINAL" })?.url {
                if let url = URL(string: originalUrlString) {
                    viewModel.presentImage(url: url)
                }
            }
        } else if fileType.isEmpty {
            let newVC = StorageViewController(viewModel: viewModel, navigationTitle: name)
            navigationController?.pushViewController(newVC, animated: true)
            viewModel.fetchCurrentData(navigationTitle: name, path: path)
        } else {
            viewModel.presentDocumet(name: name, type: .pdf, fileType: fileType)
        }
       print(fileType)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let model = modelReturn(indexPath: indexPath)
        let name = model.name
        let path = model.path
        let file = model.file
        let type = model.type ?? "dir"
        let publicUrl = model.publicUrl
        return UIContextMenuConfiguration.contextMenuConfiguration(for: .full,
                                                                   viewModel: viewModel,
                                                                   name: name,
                                                                   path: path,
                                                                   file: file, publicUrl: publicUrl,
                                                                   type: type,
                                                                   viewController: self)
    }
}

extension StorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numbersOfRowInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, 
                                                            for: indexPath) as? CollectionViewCell else {
            fatalError("Wrong cell")
        }
        let model = cellDataSource[indexPath.row]
        cell.configure(model)
        return cell
    }
}

extension StorageViewController: StorageViewControllerProtocol {
    func logout() {
        
    }
    
    func reloadCollectionView(collectionView: UICollectionView) {
        
    }
}

