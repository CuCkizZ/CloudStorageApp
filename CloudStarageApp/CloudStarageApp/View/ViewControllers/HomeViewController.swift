import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol
    var cellDataSource: [Files] = MappedDataModel.get()
//    var mapData: [Files] = []
    
    private lazy var titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.text = "Last One"
        return label
    }()
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
        setupConstraints()
        
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.contentMode = .center
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "vCell")
        //collectionView.register(HCollectionViewCell.self, forCellWithReuseIdentifier: "hCell")
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vCell", for: indexPath) as! HomeCollectionViewCell
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vCell", for: indexPath) as! HCollectionViewCell
        let model = viewModel.mapData[indexPath.row]
        cell.configure(model)
        
        return cell
    }
}


