//
//  GettinLinkView.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 08.09.2024.
//

import UIKit

private let alertTite = String(localized: "Getting link", table: "Messages+alertsLocalizable")

final class GettinLinkView: UIView {
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stateLabel, activityIndicator])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = -60
        stack.backgroundColor = .systemGray6.withAlphaComponent(0.98)
        stack.layer.cornerRadius = 20
        return stack
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.text = alertTite
        label.font = .Inter.semiBold.size(of: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GettinLinkView {
    
    func setupLayout() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        backgroundColor = .gray.withAlphaComponent(0.3)
        addSubview(stackView)
        activityIndicator.startAnimating()
    }

    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(134)
            make.width.equalTo(288)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

