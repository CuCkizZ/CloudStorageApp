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
    private var refresher = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    private var viewModel: StorageViewModelProtocol
    private var cellDataSource: [CellDataModel] = []
    
    //MARK: CollectionView
    
    private var selectedStyle: PresentationStyle = .table
    private lazy var uploadButton = CSUploadButton()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 33)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    init(viewModel: StorageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData(path: "")
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
        setupConstraints()
        
    }
    
    func setupView() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    func SetupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: selectedStyle.buttonImage, style: .plain, target: self, action: #selector(changeContentLayout))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storage"
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
    
    @objc func pullToRefresh() {
        //xxviewModel.fetchData()
        refresher.endRefreshing()
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
        uploadButton.addAction(UIAction { [weak self] action in
            guard let self = self else { return }
            let actionSheet = UIAlertController(title: "What to do", message: nil, preferredStyle: .actionSheet)
            let newFolder = UIAlertAction(title: "New Folde", style: .default) { _ in
                
                let enterNameAlert = UIAlertController(title: "New folder", message: nil, preferredStyle: .alert)
                enterNameAlert.addTextField { textField in
                    textField.placeholder = "Enter the name"
                }
                let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned enterNameAlert] _ in
                    let answer = enterNameAlert.textFields?[0]
                    self.viewModel.createNewFolder(answer?.text ?? "")
                }
                enterNameAlert.addAction(submitAction)
                self.present(enterNameAlert, animated: true)
            }
            let newFile = UIAlertAction(title: "New File", style: .default)
            let cancle = UIAlertAction(title: "Cancle", style: .cancel)
            
            actionSheet.addAction(newFolder)
            actionSheet.addAction(newFile)
            actionSheet.addAction(cancle)
            self.present(actionSheet, animated: true)
        },
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
        uploadButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(40)
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension StorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = cellDataSource[indexPath.row].path
        viewModel.pagination(name)
        print(name)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let name = cellDataSource[indexPath.item].name
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.viewModel.deleteFile(name)
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                // Handle share action
            }
            let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil.circle")) { _ in
                // viewmodel
            }
            return UIMenu(title: "", children: [deleteAction, shareAction, renameAction])
        }
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

extension StorageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 16.0)
    }
}


