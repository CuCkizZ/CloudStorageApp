//
//  NetworkMonitoringProtocol.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 16.08.2024.
//

import UIKit.UIView

protocol NetworkMonitoringProtocol {
    func setupNetworkStatusView(_ networkStatusView: UIView)
    func setupMonitoringLabel(_ networkStatusView: UIView)
    func showNetworkStatusView(_ networkStatusView: UIView)
    func hideNetworkStatusView(_ networkStatusView: UIView)
}
