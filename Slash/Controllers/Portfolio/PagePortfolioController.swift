//
//  ETCController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class PagePortfolioController: UIPageViewController {
        
    fileprivate lazy var pages: [UIViewController] = {
        let page1 = PieViewController()
        let page2 = BarViewController()

        return [page1, page2]
    }()
    
    var pageControl = UIPageControl()
    
    func configurePageControl() {
        pageControl = UIPageControl()
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.25)
        self.pageControl.currentPageIndicatorTintColor = .white
        self.view.addSubview(pageControl)
        //: Constraints for pageControl
        pageControl.anchor(top: nil, bottom: self.view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 12)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        configurePageControl()
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    @objc func moveToNextController() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        self.pageControl.currentPage = pages.index(of: nextViewController)!
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension PagePortfolioController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
    
}

extension PagePortfolioController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewControllerIndex = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.index(of: viewControllerIndex)!
    }
}
