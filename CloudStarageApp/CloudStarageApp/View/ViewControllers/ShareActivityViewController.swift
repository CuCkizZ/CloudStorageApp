//
//  ShareActivityViewController.swift
//  UIActiviTyTest
//
//  Created by Nikita Beglov on 06.08.2024.
//

import UIKit
import SnapKit



final class ShareActivityViewController: UIViewController {
    
    private let viewModel: ShareActivityViewModel
    private var typeOfView: TypeOfConfigDocumentVC?
    
    private lazy var fileButton = UIButton()
    private lazy var linkButton = UIButton()
    private lazy var textShare = UILabel()
    private lazy var stack = UIStackView(arrangedSubviews: [textShare, fileButton, linkButton])
    private var shareLink: String
    
    init(viewModel: ShareActivityViewModel, shareLink: String) {
        self.viewModel = viewModel
        self.shareLink = shareLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
}
 
private extension ShareActivityViewController {
    
    func setupLayout() {
        view.backgroundColor = .lightGray
        setupStackView()
        setupButtons()
    }
    
    func setupStackView() {
        view.addSubview(stack)
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    func configure() {
    }
    
    
    func setupButtons() {
        textShare.text = "What do tou want to share?"
        textShare.textAlignment = .center
        textShare.textColor = .white
        fileButton.setTitle("Share file", for: .normal)
        linkButton.setTitle("Share link", for: .normal)
        
        linkButton.addTarget(self, action: #selector(getShareLink), for: .touchUpInside)
        
        fileButton.backgroundColor = .yellow
        linkButton.backgroundColor = .yellow
        linkButton.setTitleColor(.black, for: .normal)
        fileButton.setTitleColor(.black, for: .normal)
        
        fileButton.layer.cornerRadius = 10
        linkButton.layer.cornerRadius = 10
        
        textShare.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        fileButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        linkButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
    }
    
    @objc func copyShare() {
        UIPasteboard.general.string = self.shareLink
        self.dismiss(animated: true)
    }
    
    @objc func getShareLink(shareLink: String) {
//        copyShare()
//        let text = "share"
//        let avc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//        DispatchQueue.main.async {
//            self.present(avc, animated: true)
//        }
        
    }
}
