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
    private var refresher = UIRefreshControl()
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    private var viewModel: PublickStorageViewModelProtocol
    private lazy var cellDataSource: [PublicItem] = []
    
    //MARK: CollectionView
    private lazy var uploadButton = CSUploadButton()
    
    private var selectedStyle: PresentationStyle = .table
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 33)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    
    
    init(viewModel: PublickStorageViewModelProtocol) {
        self.viewModel = viewModel
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
                    //self.collectionView.reloadData()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
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
        title = "Published"
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
    
    //   MARK: Objc Methods
    
    @objc func pullToRefresh() {
        viewModel.fetchData()
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
    
    func setupButtonUp() {
        uploadButton.action = { [weak self] in
            guard let self = self else { return }
            self.tap()
        }
    }
    
    @objc func tap() {
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
    
    func copyShare(share: URL) {
        UIPasteboard.general.url = share
    }
    
    func sharePresent(shareLink: String) {
        let vm = ShareActivityViewModel()
        let shareVC = ShareActivityViewController(viewModel: vm, shareLink: shareLink)
        if let sheet = shareVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                self.view.bounds.height / 4
            })]
            
            self.present(shareVC, animated: true)
        }
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
            make.height.width.equalTo(40)
        }
    }
}

extension PublicStorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.presentDetailVC(path: "")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let model = cellDataSource[indexPath.row]
        guard let linkString = model.publicUrl else { return nil}
        let name = model.name
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.viewModel.deleteFile(name)
            }
            
            let unpublishAction = UIAction(title: "Unpublish", image: UIImage(systemName: "link")) { _ in
                self.viewModel.unpublishFile(model.path)
            }
            
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.sharePresent(shareLink: String(describing: linkString))
                self.copyShare(share: linkString)
                print(linkString)
            }
            let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil.circle")) { _ in
                let enterNameAlert = UIAlertController(title: "New name", message: nil, preferredStyle: .alert)
                enterNameAlert.addTextField { textField in
                    textField.placeholder = "Enter the name"
                    
                }
                let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned enterNameAlert] _ in
                    if let answer = enterNameAlert.textFields?[0], let newName = answer.text {
                        self.viewModel.renameFile(oldName: name, newName: newName)
                    }
                }
                enterNameAlert.addAction(submitAction)
                self.present(enterNameAlert, animated: true)
            }
            return UIMenu(title: "", children: [deleteAction, unpublishAction, shareAction, renameAction])
        }
    }
}

extension PublicStorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(cellDataSource.count, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID,
                                                            for: indexPath) as? CollectionViewCell else {
            fatalError("Wrong cell")
        }
        let model = cellDataSource[indexPath.row]
        
        cell.publickConfigure(model)
        return cell
    }
}

extension PublicStorageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 16.0)
    }
}


