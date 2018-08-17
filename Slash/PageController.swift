//
//  PageController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class PageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    let pageController: UIPageControl = {
        let pc = UIPageControl()
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let initialPage = 2
        let page1 = BCHController()
        let page2 = LTCController()
        let page3 = BTCController()
        let page4 = ETHController()
        let page5 = ETCController()
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        self.pages.append(page4)
        self.pages.append(page5)
        self.setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        //: PageController
        self.pageController.numberOfPages = pages.count
        self.pageController.currentPage = initialPage
        self.view.addSubview(pageController)
        pageController.anchor(top: nil, bottom: self.view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: 0, height: 20)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.index(of: viewController) else { return nil }
        if (viewControllerIndex == 0) {
            //: Go to the last page
            return self.pages.last
        } else {
            return self.pages[viewControllerIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.index(of: viewController) else { return nil }
        if (viewControllerIndex < self.pages.count - 1) {
            //: Go to next page
            return self.pages[viewControllerIndex + 1]
        } else {
            //: Go back to first page
            return self.pages.first
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //: Update the pageController index
        guard let viewControllers = pageViewController.viewControllers, let viewControllerIndex = self.pages.index(of: viewControllers[0]) else {return}
        self.pageController.currentPage = viewControllerIndex
        
    }
}
