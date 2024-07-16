//
//  BigButtonView.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 15.07.2024.
//

import UIKit
import SnapKit

final class CSBlueButton: UIButton {
    
    var action: (() -> Void)?
    //private lazy var button = UIButton()
    
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

private extension CSBlueButton {
    
    private func setupButton() {
        self.setTitle("Далее", for: .normal)
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.titleLabel?.font = .Inter.light.size(of: 16)
        self.backgroundColor = AppColors.standartBlue
        self.layer.cornerRadius = 12
    }
    
    @objc private func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
