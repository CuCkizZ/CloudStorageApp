//
//  CSChangeLayoutButton.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 15.08.2024.
//

import UIKit

final class CSChangeLayoutButton: UIButton {

    var action: (() -> Void)?
    
    init() {
        super .init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private Setup Methods

private extension CSChangeLayoutButton {
    
    func setupButton() {
        //self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        //self.titleLabel?.font = .Inter.light.size(of: 16)
        //self.setTitleColor(.white, for: .application)
        //self.backgroundColor = AppColors.standartBlue
        //self.layer.cornerRadius = 12
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
