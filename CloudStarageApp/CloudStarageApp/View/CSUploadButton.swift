//
//  CSUploadButton.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 30.07.2024.
//

import UIKit
import SnapKit

final class CSUploadButton: UIButton {
    
    private let uploadImage = "folder.badge.plus"
    var action: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        setImage(UIImage(systemName: uploadImage)?.withTintColor(AppColors.standartBlue, 
                                                                 renderingMode: .alwaysOriginal), for: .normal)
        backgroundColor = .systemGray6.withAlphaComponent(0.9)
        clipsToBounds = true
        layer.cornerRadius = 20
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 50),
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
