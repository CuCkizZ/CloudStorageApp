//
//  CSUploadButton.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 30.07.2024.
//

import UIKit

class CSUploadButton: UIButton {
    init(target: Any, action: Selector) {
        super.init(frame: .zero)
        self.setImage(UIImage(resource: .uploadButton), for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
