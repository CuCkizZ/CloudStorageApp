//
//  OnboardingViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.07.2024.
//

import UIKit
import SnapKit

protocol OnboardingViewControllerProtocol {
    
}

final class OnboardingViewController: UIViewController {
    
    private let viewModel: OnboardingViewModelProtocol
    private var pages: [OnboardingPageViewController]
    
    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageControl = UIPageControl()
    private lazy var onboardingButton = CSBlueButton()
    
    init(pages: [OnboardingPageViewController] = [OnboardingPageViewController](), viewModel: OnboardingViewModelProtocol) {
        self.pages = pages
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageView()
        setupPageControl()
        setupButton()
    }
}
    
private extension OnboardingViewController {
    
    func setupPageView() {
        view.backgroundColor = .white
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        guard let firstPage = pages.first else { return }
        pageViewController.setViewControllers([firstPage], direction: .forward, animated: true)
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = AppColors.customGray
        pageControl.currentPageIndicatorTintColor = AppColors.standartBlue
        pageControl.backgroundStyle = .automatic
        
        view.addSubview(pageControl)
        view.addSubview(onboardingButton)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(140)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func setupButton() {
        onboardingButton.action = { [weak self] in
            guard let self = self else { return }
            self.buttonPressed()
        }
        
        onboardingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc func buttonPressed() {
        switch pageControl.currentPage {
        case 0:
            pageControl.currentPage = 1
            pageViewController.setViewControllers([pages[1]], direction: .forward, animated: true)
        case 1:
            pageControl.currentPage = 2
            pageViewController.setViewControllers([pages[2]], direction: .forward, animated: true)
            onboardingButton.setTitle("Войти")
        case 2:
            viewModel.onbordingFinish()
        default:
            break
        }
    }
}


extension OnboardingViewController: OnboardingViewControllerProtocol {
    
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController else { return UIViewController() }
        guard let currentIndex = pages.firstIndex(of: pageVC),
              currentIndex > 0
        else { return nil }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController else { return UIViewController() }
        guard let currentIndex = pages.firstIndex(of: pageVC),
              currentIndex < pages.count - 1
        else { return nil }
        return pages[currentIndex + 1]
    }
    
}


extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let firstVC = pendingViewControllers.first as? OnboardingPageViewController {
            if let index = pages.firstIndex(of: firstVC) {
                pageControl.currentPage = index
                if index == 2 { onboardingButton.setTitle("Войти")
                } else {
                    onboardingButton.setTitle("Далее")
                }
            }
        }
    }
}
