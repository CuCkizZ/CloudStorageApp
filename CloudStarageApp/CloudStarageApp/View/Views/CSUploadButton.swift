//
//  CSUploadButton.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 30.07.2024.
//

import UIKit
import SnapKit

class CSUploadButton: UIButton {
    
    var action: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        //let view = UIView()
        setImage(UIImage(systemName: "folder.badge.plus"), for: .normal)
        backgroundColor = .systemGray6.withAlphaComponent(0.9)
        clipsToBounds = true
        layer.cornerRadius = 20
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 50),
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
    
}
