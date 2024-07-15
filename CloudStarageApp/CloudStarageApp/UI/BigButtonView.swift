//
//  BigButtonView.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 15.07.2024.
//

import UIKit
import SnapKit

final class BigButtonView: UIView {
    
    var action: (() -> Void)?
    private lazy var button = UIButton()
    
    init() {
        super .init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String?) {
        button.setTitle(title, for: .normal)
    }
}

// MARK: Private Setup Methods

private extension BigButtonView {
    
    private func setupView() {
        setupButton()
    }
    
    private func setupButton() {
        addSubview(button)
        button.setTitle("Далее", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.titleLabel?.font = .Inter.light.size(of: 16)
        button.backgroundColor = AppColors.standartBlue
        button.layer.cornerRadius = 10
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
