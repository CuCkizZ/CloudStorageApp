//
//  InfoView.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 27.08.2024.
//

import UIKit
import SnapKit

private enum InfoViewConstants {
    
    static let infoTitel = String(localized: "File information", table: "InfoViewLocalizable")
    
    enum image {
        static let nameIcon = "doc.richtext"
        static let dateIcon = "calendar.badge.plus"
        static let sizeIcon = "externaldrive"
    }
}

final class InfoView: UIView {
    
    private let viewModel: PresentImageViewModelProtocol
    
    private lazy var headerLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var sizeLabel = UILabel()
    private lazy var nameIcon = UIImageView(image: UIImage(systemName: InfoViewConstants.image.nameIcon))
    private lazy var dateIcon = UIImageView(image: UIImage(systemName: InfoViewConstants.image.dateIcon))
    private lazy var sizeIcon = UIImageView(image: UIImage(systemName: InfoViewConstants.image.sizeIcon))
    private lazy var iconStacView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameIcon, dateIcon, sizeIcon])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, dateLabel, sizeLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 16
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconStacView, infoStackView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    init(viewModel: PresentImageViewModelProtocol, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: CellDataModel) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        if let bytes = model.size {
            sizeLabel.text = viewModel.sizeFormatter(bytes: bytes)
        }
    }
}

private extension InfoView {
    
    func setupLayout() {
        setupInfoView()
        setupLabels()
        setupConstaints()
    }
    
    func setupInfoView() {
        layer.cornerRadius = 20
        addSubview(headerLabel)
        addSubview(mainStackView)
        backgroundColor = .white
        mainStackView.backgroundColor = .clear
    }
    
    func setupLabels() {
        headerLabel.text = InfoViewConstants.infoTitel
        headerLabel.font = .Inter.regular.size(of: 17)
        nameLabel.font = .Inter.light.size(of: 16)
        dateLabel.font = .Inter.light.size(of: 16)
        sizeLabel.font = .Inter.light.size(of: 16)
        nameLabel.lineBreakMode = .byCharWrapping
    }
    
    func setupConstaints() {
        headerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.bottom.equalTo(mainStackView.snp.top).inset(-16)
        }
        mainStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
