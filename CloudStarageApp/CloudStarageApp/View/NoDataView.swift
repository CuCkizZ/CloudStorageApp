//
//  NoDataView.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 09.09.2024.
//

import UIKit
import SnapKit

final class NoDataView: UIView {
    
    private let noDataText = String(localized: "You don't have any published files yet", table: "Messages+alertsLocalizable")
    
    private lazy var noDataImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .noData)
        return imageView
    }()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = noDataText
        label.font = .Inter.light.size(of: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [noDataImage, noDataLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NoDataView {
    
    func setupLayout() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
