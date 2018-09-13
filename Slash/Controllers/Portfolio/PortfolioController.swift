//
//  LTCController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import Charts

class PortfolioController: UIViewController {
  
    fileprivate let cellID = "coinID"
    var user: User = UserDefaults.standard.getUser() //: Very handy
    var coinHoldings = UserDefaults.standard.getUser().getAllHoldings()
    let options = CurrencyFormatterOptions()
    var coins = [CoinDetail]()
    var previousPortfolioValue: String = String()
    fileprivate var previousGainValue: String = String()
    fileprivate var totalGainLoss: Double = 0.0
    
    let customRed = UIColor(red:0.94, green:0.31, blue:0.11, alpha:1.0)
    let customGreen = UIColor(red:0.27, green:0.75, blue:0.14, alpha:1.0)
    
    let pagePortfolioController: PagePortfolioController = {
        let pvc = PagePortfolioController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pvc.view.translatesAutoresizingMaskIntoConstraints = false
        pvc.view.backgroundColor = .clear
        return pvc
    }()
    
    var totalPortfolioValue: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font =  UIFont(name: "AvenirNext-DemiBold", size: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(convertPortfolioValue), for: .touchUpInside)
        return button
    }()
    var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 52, green: 53, blue: 69)
        return view
    }()
    var changeLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(red:0.27, green:0.75, blue:0.14, alpha:1.0)
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var coinCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.rgb(red: 35, green: 36, blue: 53)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PortfolioCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    
    @objc func convertPortfolioValue() {
        totalPortfolioValue.isSelected = !totalPortfolioValue.isSelected
        let btcAmount = convertToBTC(priceAmount: user.balance())
        let btcValue = String(format: "₿%.9f", btcAmount)
        
        //: Lets convert the change label text as well
        let changeBTCAmount = convertToBTC(priceAmount: totalGainLoss)
        let changeBTCValue = String(format: "₿%.9f", changeBTCAmount)
        
        let text = totalPortfolioValue.isSelected ? btcValue : previousPortfolioValue
        let changeText = totalPortfolioValue.isSelected ? changeBTCValue : previousGainValue
        totalPortfolioValue.setTitle(text, for: .normal)
        changeLabel.text = changeText
    }
    
    func convertToBTC(priceAmount: Double) -> Double {
        //: First get the current BTC price
        let btcUSD = user.getCoinPrice(coinName: "Bitcoin")
        let USDtoBTC = 1/btcUSD
        return priceAmount * USDtoBTC
    }
    
    func calculateGainLoss(coinName: String, coinPrice: Double) -> Double {
        //: Lets get the coin detail
        if let coin = coins.first(where: {$0.officialName() == coinName}) {
            let percent = coin.percent() //: This is the day percentage for the coin
            let originalPrice =  coinPrice / (1 + percent/100) // equivalent = coinPrice * (100/(100 + percent))
            let gainLoss = (coinPrice - originalPrice)
            UserDefaults.standard.setGainLoss(percent: gainLoss, coin: coinName) //: Perhaps do something with this value later?
            return gainLoss
        } else {
            return 0.0
        }
    }
    
    func calculateTotalGainLoss() {
        for coin in coinHoldings {
            if let coinDetail = coins.first(where: {$0.officialName() == coin}) {
                let percent = coinDetail.percent() //: This is the day percentage for the coin
                let currentPrice = user.getTotalCost(coinName: coin)
                let originalPrice =  currentPrice / (1 + percent/100) // equivalent = coinPrice * (100/(100 + percent))
                let gainLoss = (currentPrice - originalPrice)
                totalGainLoss += gainLoss
            }
        }
        //: Keep track of all the coin gains/loss
        changeLabel.text = "\(CurrencyFormatter.sharedInstance.formatAmountString("\(totalGainLoss)", currency: "USD", options: options)) today"
        changeLabel.textColor = (totalGainLoss < 0) ? self.customRed : self.customGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Portfolio"
        
        view.backgroundColor = UIColor.rgb(red: 43, green: 44, blue: 62)
        self.addChild(pagePortfolioController)
        self.view.addSubview(pagePortfolioController.view)
        self.view.addSubview(totalPortfolioValue)
        self.view.addSubview(dividerView)
        self.view.addSubview(changeLabel)
        self.view.addSubview(coinCollectionView)
        setupViews()
        
        options.showPositivePrefix = true
        options.showNegativePrefix = true
        
        calculateTotalGainLoss()
        previousPortfolioValue = totalPortfolioValue.titleLabel?.text  ?? ""
        previousGainValue = changeLabel.text ?? ""
    }
    
    func setupViews() {
        
        if #available(iOS 11, *) {
            pagePortfolioController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        } else {
             pagePortfolioController.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 5).isActive = true
        }
         pagePortfolioController.view.anchor(top: nil, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 300)
        
        totalPortfolioValue.anchor(top: pagePortfolioController.view.bottomAnchor, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: (view.bounds.width / 2), height: 54.6)
        totalPortfolioValue.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let width = (view.bounds.width / 2) - 50
        dividerView.anchor(top: totalPortfolioValue.bottomAnchor, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: width, height: 1)
        dividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeLabel.anchor(top: dividerView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 45)
        
        coinCollectionView.anchor(top: changeLabel.bottomAnchor, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//: MARK - UICollectionViewDelegate, UICollectionViewDataSource
extension PortfolioController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinHoldings.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! PortfolioCell
        cell.nameLabel.text = coinHoldings[indexPath.item]
        let holdingAmount = user.getCoinBalance(coinName: coinHoldings[indexPath.item])
        let holdingText = String(format: "%.2f%", holdingAmount)
        cell.holdingLabel.text = "≈ " + holdingText
        
        let coinPrice = user.getTotalCost(coinName: coinHoldings[indexPath.item])
        cell.totalValueLabel.text = CurrencyFormatter.sharedInstance.formatAmount(coinPrice, currency: "USD", options: nil)
        
        //: Calulate the coin gain/loss
        let calculatedGain = self.calculateGainLoss(coinName: coinHoldings[indexPath.item], coinPrice: coinPrice)
        cell.gainLossLabel.text = "\(CurrencyFormatter.sharedInstance.formatAmountString("\(calculatedGain)", currency: "USD", options: options))"
        cell.gainLossLabel.textColor = (calculatedGain < 0) ? self.customRed : self.customGreen
        
        cell.imageView.image = UIImage(named: coinHoldings[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PortfolioCell
        let holdingAmount = user.getCoinBalance(coinName: coinHoldings[indexPath.item])
        let coinPrice = user.getTotalCost(coinName: coinHoldings[indexPath.item])
        
        switch cell.currentTap {
        case 0:
            cell.holdingLabel.text = String(format: "%.9f%", holdingAmount)
            cell.currentTap += 1
        case 1:
            // Convert to btc
            cell.totalValueLabel.text = String(format: "₿%.9f", convertToBTC(priceAmount: coinPrice))
            cell.currentTap += 1
        case 2:
            cell.holdingLabel.text = "≈ " + String(format: "%.2f%", holdingAmount)
            cell.totalValueLabel.text = CurrencyFormatter.sharedInstance.formatAmount(coinPrice, currency: "USD", options: nil)
            cell.currentTap = 0
        default:
            return
        }
    }
}

//: MARK - UICollectionViewDelegateFlowLayout
extension PortfolioController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
