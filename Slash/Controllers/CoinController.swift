//
//  DataViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import Charts

class CoinController: DataController {
    
    let priceContentView = PriceContentView()
    var coin = CoinDetail()
    var chartColor = UIColor()
    lazy var chartView = ChartView()
    fileprivate var buttonArray = [CustomGrayButton]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        //scrollView.delegate = self
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.20, green:0.23, blue:0.27, alpha:1.0)
        return view
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = CGFloat(12)
        return stackView
    }()
    
    lazy var button1: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1H", for: .normal)
        return button
    }()
    lazy var button2: CustomGrayButton = {
        let button = CustomGrayButton()
        button.defaultChosen() //: 1D button should show it is tapped by default
        button.setTitle("1D", for: .normal)
        return button
    }()
    lazy var button3: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1W", for: .normal)
        return button
    }()
    lazy var button4: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1M", for: .normal)
        return button
    }()
    lazy var button5: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1Y", for: .normal)
        return button
    }()
    lazy var button6: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("All", for: .normal)
        return button
    }()
    func setupButtons() {
        buttonArray = [button1, button2, button3, button4, button5, button6]
        buttonArray.forEach({ $0.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside) })
    }
    
    @objc func buttonTapped(sender: CustomGrayButton) {
        buttonArray.forEach({$0.defaultState()})
        sender.showTappedColor()
        
        guard let rangeText = sender.titleLabel?.text else {
            return
        }
        
        self.getHistoricData(coinID: coin.id, selectedRange: rangeText)
        let newData = self.chartDataEntry.reversed() as [ChartDataEntry]
    
        
        chartView.setData(values: newData, lineColor: chartColor)
        chartView.notifyDataSetChanged()
        chartView.data?.notifyDataChanged()
        
    }
    
    func formatPrice(value: Double, isScrolling: Bool) {
        //: Modify the percentLabel, ex: -$1,172.30 (14.90%)
        var difference = 0.0, percent = 0.00
        let options = CurrencyFormatterOptions()
        options.showPositivePrefix = true
        options.showNegativePrefix = true
        
        difference = isScrolling ? coin.difference(to: value) : coin.difference()
        percent = isScrolling ? coin.percent(to: value) : coin.percent()
        
        let percentStr = String(format: "  (%.2f%%)", percent)
        priceContentView.percentageLabel.text = CurrencyFormatter.sharedInstance.formatAmount(difference, currency: "USD", options: options) + percentStr
        if !isScrolling { priceContentView.percentageLabel.text! += " today"} //: FIXME- Will be different depending on the time frame
        priceContentView.percentageLabel.textColor = (difference < 0) ? priceContentView.customRed : priceContentView.customGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = coin.officialName() + " Price"
        
        self.priceContentView.coinPriceLabel.text = CurrencyFormatter.sharedInstance.formatAmount(coin.validCurrentPrice(), currency: "USD", options: nil)
        formatPrice(value: 0.0, isScrolling: false)
        
        chartView.delegate = self
        chartView.xAxis.labelFont = UIFont(name: "AvenirNext-Regular", size: 11)!
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(priceContentView)
        contentView.addSubview(chartView)
        contentView.addSubview(stackView)
        
        setupButtons()
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        stackView.addArrangedSubview(button4)
        stackView.addArrangedSubview(button5)
        stackView.addArrangedSubview(button6)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        scrollView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        contentView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
        
        if #available(iOS 11, *) {
            priceContentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            priceContentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        }
        priceContentView.anchor(top: nil, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 130)
        
        chartView.anchor(top: priceContentView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: -3, paddingBottom: 0, paddingLeft: -9, paddingRight: -9, width: 0, height: 340)
        
        stackView.anchor(top: chartView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 22, paddingRight: 22, width: 0, height: 44)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension CoinController : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Chart description: \(entry.description)")
        //: Y-Value is the price
        priceContentView.coinPriceLabel.text = CurrencyFormatter.sharedInstance.formatAmount(entry.y, currency: "USD", options: nil)
        
        //: X-Value is time
        let date = Date(timeIntervalSince1970: entry.x)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "h:mm a EEEE, MMM dd, yyyy" // 4:00 PM Saturday, Aug 25, 2018
        let strDate = dateFormatter.string(from: date)
        priceContentView.dateLabel.text = strDate
        
        // Get the difference and percentage
        formatPrice(value: entry.y, isScrolling: true)
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //: If user deselects the chart, place the original price back
        priceContentView.coinPriceLabel.text =  "$" + coin.currentPrice
        priceContentView.dateLabel.text = ""
        formatPrice(value: 0.0, isScrolling: false)
    }
    
}
