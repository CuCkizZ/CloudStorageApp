//
//  HomeViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol
    var cellDataSource: [CellDataModel] = []
    
    private lazy var titleLable = UILabel()
    private lazy var collectionView: UICollectionView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        mapModel()
    }
    
    func mapModel() {
        cellDataSource.append(contentsOf: repeatElement(CellDataModel(name: "Наименование", size: "5 кб", date: "12.12.32 33:22", icon: UIImage(resource: .file)), count: 5))
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
        view.addSubview(titleLable)
        setupCollectionView()
        setupTitleLable()
    }
    
    func setupTitleLable() {
        titleLable.text = "Last one"
        titleLable.font = .Inter.bold.size(of: 30)
        titleLable.textColor = .black
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.contentMode = .left
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellDataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        let model = cellDataSource[indexPath.row]
        cell.configure(model)
        
        return cell
    }
}


