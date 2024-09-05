//
//  PDF.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import UIKit
import PDFKit
import SnapKit

class PDFViewController: UIViewController {
    
    var document = PDFView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
}

private extension
