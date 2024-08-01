//
//  CSUploadButton.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 30.07.2024.
//

import UIKit

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
        self.setImage(UIImage(resource: .uploadButton), for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
    
}
