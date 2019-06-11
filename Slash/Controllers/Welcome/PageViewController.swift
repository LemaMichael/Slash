//
//  PageController.swift
//  Slash
//
//  Created by Michael Lema on 8/23/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {
    
    fileprivate var timer = Timer()
    
    fileprivate lazy var pages: [UIViewController] = {
        let page1 = Page()
        page1.headingLabel.text = "Welcome"
        page1.subLabel.text = "Get live prices for your favorite cryptocurrencies."
        let page2 = Page()
        page2.headingLabel.text = "Track"
        page2.subLabel.text = "Create alerts to notify you if a coin is increasing or decreasing."
        let page3 = Page()
        page3.headingLabel.text = "Your Portfolio"
        page3.subLabel.text = "Watch your coin portfolio progress by letting Slash do the hard work!"
        return [page1, page2, page3]
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
        startTimer()
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(moveToNextController), userInfo: nil, repeats: true)
    }
    func resetTimer() {
        self.timer.invalidate()
        startTimer()
    }
    @objc func moveToNextController() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        self.pageControl.currentPage = pages.firstIndex(of: nextViewController)!
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        resetTimer()
        let viewControllerIndex = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.firstIndex(of: viewControllerIndex)!
    }
}
