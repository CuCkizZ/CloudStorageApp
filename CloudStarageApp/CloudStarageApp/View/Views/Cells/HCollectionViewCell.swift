//
//  HCollectionViewCell.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 19.07.2024.
//

import UIKit
import SnapKit

final class HCollectionViewCell: UICollectionViewCell {
    private let view = UIView()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .file)
        return imageView
    }()
    private lazy var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.backgroundColor = .red
        
        contentView.layer.masksToBounds = true
       
        //view.backgroundColor = .blue
        
        contentView.addSubview(contentImageView)
        contentView.addSubview(nameLabel)
        
    }
    
    func configure(_ model: Files) {
        nameLabel.text = model.name
        nameLabel.numberOfLines = 2
        nameLabel.showsExpansionTextWhenTruncated = true
        contentImageView.image = model.icon
    }
    
    func setupConstraints() {
        contentImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.bottom).inset(-10)
            make.left.right.equalToSuperview()
        }
    }
}
