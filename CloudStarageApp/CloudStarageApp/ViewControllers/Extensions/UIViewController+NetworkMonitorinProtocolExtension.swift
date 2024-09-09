//
//  UIViewController+NetworkMonitorinProtocolExtension.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 16.08.2024.
//

import UIKit
import SnapKit

private let text = String(localized: "There is no internet connection", table: "Messages+alertsLocalizable")
private let tableImage = "square.fill.text.grid.1x2"
private let gridImage = "square.grid.3x3"

extension UIViewController: NetworkMonitoringProtocol {
    
    func setupNetworkStatusView(_ networkStatusView: UIView) {
        networkStatusView.backgroundColor = .red
        let x = (view.frame.width - networkStatusView.frame.width) / 2
        networkStatusView.frame = CGRect(x: x, y: 0, width: view.frame.width / 1.3, height: 20)
        networkStatusView.layer.cornerRadius = 10
        networkStatusView.alpha = 0
        view.addSubview(networkStatusView)
        setupMonitoringLabel(networkStatusView)
    }
    
    func setupMonitoringLabel(_ networkStatusView: UIView) {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .Inter.light.size(of: 13)
        networkStatusView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(networkStatusView)
        }
    }
    
    func showNetworkStatusView(_ networkStatusView: UIView) {
        UIView.animate(withDuration: 0.5) {
            networkStatusView.frame.origin.y = 48
            networkStatusView.alpha = 1
        }
    }
    
    func hideNetworkStatusView(_ networkStatusView: UIView) {
        UIView.animate(withDuration: 0.5) {
            networkStatusView.frame.origin.y = -30
            networkStatusView.alpha = 0
        }
    }
}

extension UIViewController {
    
    enum PresentationStyle: String, CaseIterable {
        case table
        case defaultGrid
        
        var buttonImage: UIImage {
            switch self {
            case .table:
                return UIImage(systemName: tableImage)?
                    .withTintColor(AppColors.standartBlue,
                                   renderingMode: .alwaysOriginal) ?? UIImage()
            case .defaultGrid:
                return UIImage(systemName: gridImage)?
                    .withTintColor(AppColors.standartBlue,
                                   renderingMode: .alwaysOriginal) ?? UIImage()
            }
        }
    }
}
