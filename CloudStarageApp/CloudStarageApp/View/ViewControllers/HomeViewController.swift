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

final class HomeViewController: UIViewController {
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    var viewModel: HomeViewModelProtocol
    private lazy var cellDataSource: [CellDataModel] = []
    
    //MARK: CollectionView
    
    private var selectedStyle: PresentationStyle = .table {
        didSet { updatePresentationStyle() }
    }
    private var styleDelegates: [PresentationStyle: CollectionViewSelectableItemDelegate] = {
        let result: [PresentationStyle: CollectionViewSelectableItemDelegate] = [
            .table: TabledContentCollectionViewDelegate(),
            .defaultGrid: DefaultGriddedContentCollectionViewDelegate()
        ]
        return result
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    
    private lazy var uploadButton = CSUploadButton(target: self, action: #selector(uploadButtonPressed))
    
    init(viewModel: HomeViewModelProtocol) {
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
                    self.collectionView.reloadData()
                    
                } else {
                    self.activityIndicator.stopAnimating()
                    
                }
            }
        }
    }
}

// MARK: Layout

private extension HomeViewController {
    
    func setupLayout() {
        setupView()
        SetupNavBar()
        updatePresentationStyle()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    func SetupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: selectedStyle.buttonImage, style: .plain, target: self, action: #selector(changeContentLayout))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Last one"
    }
    
    
    func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.contentMode = .center
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
    }
    
    private func updatePresentationStyle() {
        collectionView.delegate = styleDelegates[selectedStyle]
        collectionView.performBatchUpdates({
            collectionView.reloadData()
        }, completion: nil)
        navigationItem.rightBarButtonItem?.image = selectedStyle.buttonImage
    }
    
    //   MARK: Objc Methods
    
    @objc private func changeContentLayout() {
        let allCases = PresentationStyle.allCases
        guard let index = allCases.firstIndex(of: selectedStyle) else { return }
        let nextIndex = (index + 1) % allCases.count
        selectedStyle = allCases[nextIndex]
    }
    
    @objc private func uploadButtonPressed() {
        uploadButton.addAction(UIAction { action in
            let ac = UIAlertController(title: "New folder", message: nil, preferredStyle: .alert)
            ac.addTextField { textField in
                textField.placeholder = "Enter the name"
            }
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
                let answer = ac.textFields?[0]
                self.viewModel.createNewFolder(answer?.text ?? "")
            }
            ac.addAction(submitAction)
            self.present(ac, animated: true)
        },
                               for: .touchUpInside)
    }
    
    
    func setupConstraints() {
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



extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.presentDetailVC()
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

extension HomeViewController: UICollectionViewDataSource {
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


