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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private Setup Methods

private extension CSChangeLayoutButton {
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
