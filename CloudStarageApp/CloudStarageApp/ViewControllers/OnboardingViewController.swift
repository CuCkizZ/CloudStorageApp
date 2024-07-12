//
//  OnboardingViewController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.07.2024.
//

import UIKit

protocol OnboardingViewControllerProtocol {
    
}

class OnboardingViewController: UIViewController {
    
    private let viewModel: OnboardingViewModelProtocol
    private var pages: [UIViewController]
    
    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageControl = UIPageControl()
    
    init(pages: [UIViewController] = [UIViewController](), viewModel: OnboardingViewModelProtocol) {
        self.pages = pages
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        setupPageView()
        setupPageControl()
    }
    
    // MARK: - Navigation
    
    func setupPageView() {
        
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
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
    
}

extension OnboardingViewController: OnboardingViewControllerProtocol {
    
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
              currentIndex > 0
        else { return nil }
        
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
              currentIndex < pages.count - 1
        else { return nil }
        
        return pages[currentIndex + 1]
    }
    
}


extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let firstVC = pendingViewControllers.first,
           let index = pages.firstIndex(of: firstVC) {
            pageControl.currentPage = index
        }
    }
}
