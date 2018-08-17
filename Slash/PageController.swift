//
//  PageController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class PageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    struct URL {
        static let btcUSD = "BTC-USD"
        static let ethUSD = "ETH-USD"
        static let ltcUSD = "LTC-USD"
        static let bchUSD = "BCH-USD"
        static let etcUSD = "ETC-USD"
    }
    var interval: TimeInterval!
    var timer: Timer!
    var firstPrice = ""
    var secondPrice = ""
    var pairs = [Pair]()
    var firstPairID: String!
    var secondPairID: String!
    var chosenPairs: [Pair] = []
    var reachability: Reachability?
    var fontPosistive: NSMutableAttributedString!
    var fontNegative: NSMutableAttributedString!
    var font:  [String : NSObject]!
    var useColouredSymbols = true
    
    let defaults = Foundation.UserDefaults.standard
    let pairsURL = "https://api.gdax.com/products"
    let green = UIColor.init(red: 22/256, green: 206/255, blue: 0/256, alpha: 1)
    let red = UIColor.init(red: 255/256, green: 73/255, blue: 0/256, alpha: 1)
    let white = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
    

    var pages = [UIViewController]()
    let pageController: UIPageControl = {
        let pc = UIPageControl()
        return pc
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func settingsTapped() {
        //: Button animation
        UIView.animate(withDuration: 0.2, animations: {
            self.settingsButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.96)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.settingsButton.transform = CGAffineTransform.identity
            })
        }
        //: FIXME: BRing up a tableViewController later
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        //: FIXME:  Change this back to 2 later
        let initialPage = 0
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
        self.view.addSubview(settingsButton)
        pageController.anchor(top: nil, bottom: self.view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: 0, height: 20)
        settingsButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 25, height: 25)
        
        setup()
        setupViews()
        fetchPairs()
        
    }
    
    func setup() {
        if let interval = defaults.object(forKey: UserDefaults.interval.rawValue) as? TimeInterval {
            self.interval = interval
        } else {
            self.interval = TimeInterval(60)  // Default is 60 seconds
            defaults.set(self.interval, forKey: UserDefaults.interval.rawValue)
        }
        
        if let firstPair = defaults.object(forKey: UserDefaults.firstPair.rawValue) as? String {
            firstPairID = firstPair
        } else {
            firstPairID = URL.btcUSD // Default
            defaults.set(firstPairID, forKey: UserDefaults.firstPair.rawValue)
        }
        
        if let secondPair = defaults.object(forKey: UserDefaults.secondPair.rawValue) as? String {
            secondPairID = secondPair
        } else {
            secondPairID = URL.ethUSD // Default
            defaults.set(secondPairID, forKey: UserDefaults.secondPair.rawValue)
        }
        
        if defaults.object(forKey: UserDefaults.colorSymbols.rawValue) == nil {
            useColouredSymbols = true // Default
            defaults.set(true, forKey: UserDefaults.colorSymbols.rawValue)
        } else {
            useColouredSymbols = defaults.bool(forKey: UserDefaults.colorSymbols.rawValue)
        }
        
        defaults.synchronize()
    }
    
    func setupViews() {
        ///:
    }
    func fetchPairs() {
        let request = URLRequest(url: Foundation.URL(string: pairsURL)!)
        
        chosenPairs.removeAll()
        
        Client.shared.getPairs(request) { (pairs) in
            self.pairs = pairs!
            
            var firstPair: Pair!
            var secondPair: Pair!
            
            for pair in self.pairs {
                
                if pair.id == self.firstPairID {
                    firstPair = pair
                }
                if pair.id == self.secondPairID {
                    secondPair = pair
                }
            }
            
            self.chosenPairs.append(firstPair)
            self.chosenPairs.append(secondPair)
            
            self.update()
            self.updateTimer()
        }
    }
    
    func update() {
        fetchPairsPrice()
    }
    func fetchPairsPrice() {
        
    }
    func updateTimer() {
        
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
