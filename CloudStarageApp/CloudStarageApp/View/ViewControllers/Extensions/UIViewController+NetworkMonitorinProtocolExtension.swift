//
//  UIViewController+NetworkMonitorinProtocolExtension.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 16.08.2024.
//

import UIKit
import SnapKit

extension UIViewController: NetworkMonitoringProtocol {
    
    func setupNetworkStatusView(_ networkStatusView: UIView) {
        networkStatusView.backgroundColor = .red
        networkStatusView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        networkStatusView.alpha = 0 // Начинаем с прозрачного состояния
        view.addSubview(networkStatusView)
        setupMonitoringLabel(networkStatusView)
    }
    
    func setupMonitoringLabel(_ networkStatusView: UIView) {
        let label = UILabel()
        label.text = "Отсутствует подключение к интернету"
        networkStatusView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(networkStatusView)
        }
    }
    
    func showNetworkStatusView(_ networkStatusView: UIView) {
        UIView.animate(withDuration: 0.5) {
            networkStatusView.frame.origin.y = 50
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
