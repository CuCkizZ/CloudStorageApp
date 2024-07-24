//
//  YandexButton.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import UIKit

final class YandexButton: UIButton {
    
    var action: (() -> Void)?
    
    init() {
        super .init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String?) {
        self.setTitle(title, for: .normal)
    }
}

// MARK: Private Setup Methods

private extension YandexButton {
    
    func setupButton() {
        self.setTitle("ЯндекID", for: .normal)
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.titleLabel?.font = .Inter.light.size(of: 16)
        self.backgroundColor = .black
        self.layer.cornerRadius = 12
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
