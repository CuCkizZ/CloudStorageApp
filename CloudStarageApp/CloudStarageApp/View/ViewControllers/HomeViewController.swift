//
//  HomeViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    lazy var titleLable = UILabel()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: view.bounds.width, height: 33)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
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
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
}


