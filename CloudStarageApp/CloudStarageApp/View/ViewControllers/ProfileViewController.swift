//
//  ProfileViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 18.07.2024.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelProtocol
    
    private lazy var titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.text = "Profile"
        return label
    }()
    
    private let totalStorageLabel = UILabel()
    private let usedStorageLabel = UILabel()
    private let leftStorageLabel = UILabel()
    
    private let usedImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let storageCircleView = UIImageView()
    
    private lazy var totalShapeLayer = CAShapeLayer()
    private lazy var usageShapeLayer = CAShapeLayer()
    private let downloadButton = UIButton()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        storageCircleView.isHidden = true
        setupLayout()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension ProfileViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(storageCircleView)
        view.addSubview(usedStorageLabel)
        view.addSubview(leftStorageLabel)
        view.addSubview(usedImageView)
        view.addSubview(leftImageView)
        view.addSubview(downloadButton)
        setupViews()
        setupConstraints()
        setupShapeLayer()
    }
    
    func setupViews() {
        setupButton()
        storageCircleView.image = UIImage(resource: .storageCircle)
        leftImageView.image = UIImage(resource: .playstore)
        usedImageView.image = UIImage(resource: .playstore)
    
        leftStorageLabel.text = "15gb - lefr"
        usedStorageLabel.text = "5gb - used"
    }
    
    func setupShapeLayer() {
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 200)
        let radius = min(view.bounds.width, view.bounds.height) / 4
        let usagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        let totalPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        usageShapeLayer.path = usagePath.cgPath
        usageShapeLayer.fillColor = UIColor.clear.cgColor
        usageShapeLayer.lineJoin = .round
        usageShapeLayer.strokeColor = AppColors.storagePink.cgColor
        usageShapeLayer.lineWidth = 40
        usageShapeLayer.strokeStart = 0.000001
        usageShapeLayer.strokeEnd = 0.000000
        

        totalShapeLayer.path = totalPath.cgPath
        totalShapeLayer.fillColor = UIColor.white.cgColor
        totalShapeLayer.strokeColor = AppColors.customGray.cgColor
        totalShapeLayer.lineWidth = 40
        totalShapeLayer.strokeStart = 0.000001
        totalShapeLayer.strokeEnd = 1

        view.layer.addSublayer(totalShapeLayer)
        view.layer.addSublayer(usageShapeLayer)
    }
    
    func setupButton() {
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.black, for: .normal)
        downloadButton.backgroundColor = .white
        downloadButton.layer.cornerRadius = 12
        downloadButton.layer.shadowColor = UIColor.black.cgColor
        downloadButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        downloadButton.layer.shadowRadius = 4
        downloadButton.layer.shadowOpacity = 0.3
        downloadButton.layer.masksToBounds = false
        
        downloadButton.addTarget(self, action: #selector(updateShapeLayer), for: .touchUpInside)
    }
    
    @objc func updateShapeLayer() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = totalShapeLayer.strokeEnd
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        totalShapeLayer.strokeEnd = 1
        totalShapeLayer.add(animation, forKey: "strokeEnd")
        
        animation.fromValue = usageShapeLayer.strokeEnd
        animation.toValue = 0.5
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        usageShapeLayer.strokeEnd = 0.5
        usageShapeLayer.add(animation, forKey: "strokeEnd")
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(16)
        }
        storageCircleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        usedImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(storageCircleView.snp.bottom).inset(-30)
            make.height.width.equalTo(30)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(usedImageView.snp.bottom).inset(-10)
            make.height.width.equalTo(30)
        }
        usedStorageLabel.snp.makeConstraints { make in
            make.left.equalTo(usedImageView.snp.right).inset(-10)
            make.top.equalTo(storageCircleView.snp.bottom).inset(-35)
        }
        leftStorageLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).inset(-10)
            make.top.equalTo(usedStorageLabel.snp.bottom).inset(-20)
        }
        downloadButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(leftStorageLabel.snp.bottom).inset(-50)
            
        }
    }
}
