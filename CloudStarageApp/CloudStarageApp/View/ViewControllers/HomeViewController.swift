import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol
    var cellDataSource: [Files] = MappedDataModel.get()
//    var mapData: [Files] = []
    private lazy var directionButton = UIButton()
    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.itemSize = CGSize(width: 100, height: 100)
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        return collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: view.bounds.width, height: 33)
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
        //viewModel.mapModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        collectionView.reloadData()
        
       
    }
}

// MARK: Layout

private extension HomeViewController {
    
    func setupLayout() {
        setupView()
        SetupNavBar()
       // updatePresentationStyle()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    func SetupNavBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: selectedStyle.buttonImage, style: .plain, target: self, action: #selector(changeContentLayout))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Last one"
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.contentMode = .center
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
    }
    
//    private func updatePresentationStyle() {
//        collectionView.delegate = styleDelegates[selectedStyle]
//        collectionView.performBatchUpdates({
//            collectionView.reloadData()
//        }, completion: nil)
//        navigationItem.rightBarButtonItem?.image = selectedStyle.buttonImage
//    }
//    
//    @objc private func changeContentLayout() {
//        let allCases = PresentationStyle.allCases
//        guard let index = allCases.firstIndex(of: selectedStyle) else { return }
//        let nextIndex = (index + 1) % allCases.count
//        selectedStyle = allCases[nextIndex]
//        
//    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.presentDetailVC()
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
        let model = viewModel.mapData[indexPath.row]
        cell.configure(model)
        
        return cell
    }
}


