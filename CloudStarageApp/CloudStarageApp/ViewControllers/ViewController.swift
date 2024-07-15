//
//  ViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.storagePink
        testSetup()
    }

    func testSetup() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        label.text = "Hello World!"
        label.font = .Inter.bold.size(of: 40)
        label.textColor = .black
    }

}

