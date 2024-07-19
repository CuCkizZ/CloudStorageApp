//
//  titleLable.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 19.07.2024.
//

import UIKit

final class TitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        self.font = .Inter.bold.size(of: 40)
        self.textColor = .black
    }
    
}
