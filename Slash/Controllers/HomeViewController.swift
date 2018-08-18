//
//  HomeViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeViewController: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let coinCellId = "cellId"

    var interval: TimeInterval!
    var timer: Timer!
    var firstPrice = ""
    var secondPrice = ""
    var thirdPrice = ""
    var fourthPrice = ""
    var fifthPrice = ""
    
    var pairs = [Pair]()
    
    var firstPairID: String!
    var secondPairID: String!
    var thirdPairID: String!
    var fourthPairID: String!
    var fifthPairID: String!
    
    var chosenPairs: [Pair] = []
    var reachability: Reachability?
    var fontPosistive: NSMutableAttributedString!
    var fontNegative: NSMutableAttributedString!
    var font:  [String : NSObject]!
    var useColouredSymbols = true
    
    let defaults = Foundation.UserDefaults.standard
    let pairsURL = "https://api.pro.coinbase.com/"
    let green = UIColor.init(red: 22/256, green: 206/255, blue: 0/256, alpha: 1)
    let red = UIColor.init(red: 255/256, green: 73/255, blue: 0/256, alpha: 1)
    let white = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CoinCell.self, forCellWithReuseIdentifier: HomeViewController.coinCellId)
        return collectionView
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
        view.backgroundColor = UIColor(red:0.35, green:0.54, blue:0.90, alpha:1.0)
        self.view.addSubview(collectionView)
        self.view.addSubview(settingsButton)
        
        settingsButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 25, height: 25)
        collectionView.anchor(top: nil, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: -70, paddingLeft: 0, paddingRight: 0, width: 0, height: (self.view.frame.height / 2))
        
        //setup()
        //fetchPairs()

        // Start reachability without a hostname intially
        //setupReachability(useHostName: false)
        //startNotifier()
        
        // After 5 seconds, stop and re-start reachability, this time using a hostname
        let dispatchTime = DispatchTime.now() + Double(Int64(UInt64(5) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            //self.stopNotifier()
            //self.setupReachability(useHostName: true)
            //self.startNotifier()
        }
    }
    
    
    func setup() {
        if let interval = defaults.object(forKey: UserDefaults.interval.rawValue) as? TimeInterval {
            self.interval = interval
        } else {
            self.interval = TimeInterval(5)  // Default is 60 seconds
            defaults.set(self.interval, forKey: UserDefaults.interval.rawValue)
        }
        
        //: 1
        if let firstPair = defaults.object(forKey: UserDefaults.firstPair.rawValue) as? String {
            firstPairID = firstPair
        } else {
            firstPairID = URL.btcUSD // Default
            defaults.set(firstPairID, forKey: UserDefaults.firstPair.rawValue)
        }
        //: 2
        if let secondPair = defaults.object(forKey: UserDefaults.secondPair.rawValue) as? String {
            secondPairID = secondPair
        } else {
            secondPairID = URL.ethUSD // Default
            defaults.set(secondPairID, forKey: UserDefaults.secondPair.rawValue)
        }
        //: 3
        if let thirdPair = defaults.object(forKey: UserDefaults.thirdPair.rawValue) as? String {
            thirdPairID = thirdPair
        } else {
            thirdPairID = URL.ltcUSD // Default
            defaults.set(thirdPairID, forKey: UserDefaults.thirdPair.rawValue)
        }
        //: 4
        if let fourthPair = defaults.object(forKey: UserDefaults.fourthPair.rawValue) as? String {
            fourthPairID = fourthPair
        } else {
            fourthPairID = URL.bchUSD // Default
            defaults.set(fourthPairID, forKey: UserDefaults.fourthPair.rawValue)
        }
        //: 5
        if let fifthPair = defaults.object(forKey: UserDefaults.fifthPair.rawValue) as? String {
            fifthPairID = fifthPair
        } else {
            fifthPairID = URL.etcUSD // Default
            defaults.set(fifthPairID, forKey: UserDefaults.fifthPair.rawValue)
        }
        
        defaults.synchronize()
    }
    
    func updateTimer() {
        if timer != nil {
            if timer.isValid == true {
                timer.invalidate()
            }
        }
        
        timer = Timer(timeInterval: interval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        fetchPairsPrice()
    }

    func updateOfflineTitle() {
        DispatchQueue.main.async(execute: {
            let cells = self.collectionView.visibleCells as! Array<CoinCell>
            for cell in cells {
                cell.updateOffline()
            }
        })
    }
    
    func fetchPairsPrice() {
        for pair in chosenPairs {
            fetchStats(pair.id!, callback:  { (open, volume) in
                pair.open = open
                pair.volume = volume
            })
            
            fetchPrice(pair.id!, callback: { (price) in
                pair.price = price
                //: DONE !
            })
        }
    }
    func fetchPrice(_ pricePair:String, callback: @escaping (String?) -> Void) {
        let request = URLRequest(url: Foundation.URL(string: "\(pairsURL)/\(pricePair)/ticker")!)
        Client.shared.getPrice(request) { (price) in
            callback(price)
        }
    }
    
    func fetchStats(_ pricePair:String, callback: @escaping (String?, String?) -> Void) {
        print(pricePair)
        let request = URLRequest(url: Foundation.URL(string: "\(pairsURL)/\(pricePair)/stats")!)
        Client.shared.getStats(request) { (open, volume) in
            callback(open, volume)
        }
    }


    func fetchPairs() {
        let request = URLRequest(url: Foundation.URL(string: pairsURL)!)
        
        chosenPairs.removeAll()
        
        
        Client.shared.getPairs(request) { (pairs) in
            self.pairs = pairs!
            
            var firstPair: Pair!
            var secondPair: Pair!
            var thirdPair: Pair!
            var fourthPair: Pair!
            var fifthPair: Pair!
            
            for pair in self.pairs {
                
                if pair.id == self.firstPairID {
                    firstPair = pair
                }
                if pair.id == self.secondPairID {
                    secondPair = pair
                }
                if pair.id == self.thirdPairID {
                    thirdPair = pair
                }
                if pair.id == self.fourthPairID {
                    fourthPair = pair
                }
                if pair.id == self.fifthPairID {
                    fifthPair = pair
                }
            }
            
            self.chosenPairs.append(firstPair)
            self.chosenPairs.append(secondPair)
            self.chosenPairs.append(thirdPair)
            self.chosenPairs.append(fourthPair)
            self.chosenPairs.append(fifthPair)
            
            self.update()
            self.updateTimer()
        }
    }
    
    func updateInterval(_ interval: TimeInterval) {
        self.interval = interval
        
        defaults.set(self.interval, forKey: UserDefaults.interval.rawValue)
        defaults.synchronize()
        
        updateTimer()
    }
    
    //: Will need to do this with 5 pairs in settings tab perhaps
    func updatePair(_ isFirstPair:Bool, title: String) {
        if isFirstPair == true {
            defaults.set(title, forKey: UserDefaults.firstPair.rawValue)
            firstPairID = title
        } else {
            defaults.set(title, forKey: UserDefaults.secondPair.rawValue)
            secondPairID = title
        }
        
        defaults.synchronize()
        fetchPairs()
    }
    
    
    //MARK: Reachability
    func setupReachability(useHostName: Bool) {
        let hostName = "gdax.com"
        
        self.reachability = useHostName ? Reachability(hostname: hostName) : Reachability()
        
        reachability?.whenReachable = { reachability in
            self.fetchPairs()
        }
        reachability?.whenUnreachable = { reachability in
            self.updateOfflineTitle()
        }
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        reachability!.stopNotifier()
        reachability = nil
    }

    
    
    //: MARK: CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.coinCellId, for: indexPath) as! CoinCell
  //      cell.coinImageView.image = coinImage[indexPath.item].withRenderingMode(.alwaysTemplate)
   //     cell.coinImageView.tintColor = colors[1]
    //    cell.coinLabel.text = coinName[indexPath.item]
//
//        let pair = self.chosenPairs[indexPath.item]
//        if let first = self.chosenPairs[indexPath.item].price,
//            let quote = self.chosenPairs[indexPath.item].quoteCurrency {
//            self.firstPrice = CurrencyFormatter.sharedInstance.formatAmountString(first, currency: quote, options: nil)
//        }
        
    //    cell.update(pair, price: self.firstPrice, pairID: self.firstPairID)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60), height: (self.view.frame.height / 2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //: Adjust the cell position
        let width = self.view.frame.width
        let cellWidth = (self.view.frame.width - 60)
        let diff = (width-cellWidth) / 2
        return UIEdgeInsets(top: 0, left: diff, bottom: 0, right: diff)
    }


}
