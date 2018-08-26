//
//  DataViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import Charts

class CoinController: UIViewController {
    
    let priceContentView = PriceContentView()
    var coin = CoinDetail()
    lazy var chartView = ChartView()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = coin.officialName() + " Price"
        self.priceContentView.coinPriceLabel.text = "$" + coin.currentPrice // FIXME: Currency shouldn't be placed like this
//        self.priceContentView.percentageLabel.text = "\(coin.percent())"

        chartView.delegate = self
        chartView.xAxis.labelFont = UIFont(name: "AvenirNext-Regular", size: 11)!
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(priceContentView)
        contentView.addSubview(chartView)
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
        priceContentView.anchor(top: nil, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 18, paddingRight: 18, width: 0, height: 130)
        
        chartView.anchor(top: priceContentView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: -1, paddingBottom: 0, paddingLeft: -9, paddingRight: -9, width: 0, height: 340)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension CoinController : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Chart description: \(entry.description)")
        priceContentView.coinPriceLabel.text = String(format: "$%.2f", entry.y)
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //: If user deselects the chart, place the original price back
        priceContentView.coinPriceLabel.text =  "$" + coin.currentPrice
    }
    
}

