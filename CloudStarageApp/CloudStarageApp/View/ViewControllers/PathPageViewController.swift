//
//  PathPageViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import UIKit

final class PathPageViewController: UIViewController {
    
    private let viewModel: PathPageViewModel
    
    init(viewModel: PathPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan

        // Do any additional setup after loading the view.
    }

}
