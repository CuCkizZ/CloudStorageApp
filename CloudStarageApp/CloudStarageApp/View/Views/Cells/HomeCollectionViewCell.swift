//
//  HomeCollectionViewCell.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 17.07.2024.
//

import UIKit
import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell {
    
    private let view = UIView()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .file)
        return imageView
    }()
    private lazy var nameLabel = UILabel()
    private lazy var sizeLabel = UILabel()
    private lazy var dateLabel = UILabel()
    //private lazy var timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.backgroundColor = .white
        
        contentView.layer.masksToBounds = true
       
        //view.backgroundColor = .blue
        
        contentView.addSubview(contentImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(dateLabel)
        
        setupLabels()
        
    }
    
    func configure(_ model: CellDataModel) {
        nameLabel.text = model.name
        sizeLabel.text = model.size
        dateLabel.text = model.date
        contentImageView.image = model.icon
    }
    
}

private extension HomeCollectionViewCell {
    
    func setupLabels() {
        nameLabel.font = .Inter.regular.size(of: 15)
        sizeLabel.font = .Inter.extraLight.size(of: 13)
        dateLabel.font = .Inter.extraLight.size(of: 13)
        
        nameLabel.textColor = .black
        sizeLabel.textColor = AppColors.customGray
        dateLabel.textColor = AppColors.customGray
    }
    
    func setupConstraints() {
        
        contentImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(22)
            make.width.equalTo(25)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(contentImageView.snp.right).inset(-16)
        }
        sizeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(1)
            make.left.equalTo(contentImageView.snp.right).inset(-16)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(1)
            make.left.equalTo(sizeLabel.snp.right).inset(-5)
        }
    }
    
}
