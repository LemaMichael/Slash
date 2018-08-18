//
//  CoinCell.swift
//  Slash
//
//  Created by Michael Lema on 8/17/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import LinearProgressBar
import Charts

class CoinCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let coinPrice: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "$6,567.08"
        label.font =  UIFont(name: "AvenirNext", size: 50)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let coinPercentage: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "+240.66 (4.12%)"
        //: Green color
        label.textColor = UIColor(red:0.38, green:0.79, blue:0.00, alpha:1.0)
        //: Red color
        //: UIColor(red:1.00, green:0.29, blue:0.29, alpha:1.0)
        label.font =  UIFont(name: "AvenirNext", size: 9)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    
    let coinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font =  UIFont(name: "Avenir", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    //: https://github.com/gordoneliel/LinearProgressBar
    lazy var progressBar: LinearProgressBar = {
        let pB = LinearProgressBar()
        pB.backgroundColor = .clear
        pB.barColor = .orange
        pB.trackColor = .lightGray
        //pB.barThickness = CGFloat(5)
        pB.progressValue = CGFloat(66)
        pB.trackPadding = 25
        return pB
    }()
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        return label
    }()
    
    //: FIXME: Do chart view
    var chartView = ChartView()
    func setChartData(reference: ReferenceType, values: [ChartDataEntry]) {
        //self.referenceLabel.text = reference.rawValue.localized
        chartView.setData(values: values)
    }
    
    func setupCell() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        chartView.backgroundColor = .lightGray
        addSubview(coinImageView)
        addSubview(coinPrice)
        addSubview(coinPercentage)
        addSubview(coinLabel)
        addSubview(progressBar)
        addSubview(percentageLabel)
        addSubview(chartView)
        
        percentageLabel.text =  String(format: "%.0f%%", progressBar.progressValue)
        
        coinImageView.anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 18, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 47, height: 47)
        coinPrice.anchor(top: self.topAnchor, bottom: chartView.topAnchor, left: self.coinImageView.rightAnchor, right: nil, paddingTop: 18, paddingBottom: 0, paddingLeft: 2, paddingRight: 0, width: 125, height: 0)
        coinPercentage.anchor(top: self.topAnchor, bottom: chartView.topAnchor, left: self.coinPrice.rightAnchor, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: -5, paddingRight: 18, width: 75, height: 0)
        
        coinLabel.anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 18, paddingRight: 0, width: 243, height: 70)
        progressBar.anchor(top: coinLabel.bottomAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 18, paddingRight: 40, width: 0, height: 6)
        percentageLabel.anchor(top: coinLabel.bottomAnchor, bottom: nil, left: progressBar.rightAnchor, right: self.rightAnchor, paddingTop: 1, paddingBottom: 0, paddingLeft: 4, paddingRight: 0, width: 0, height: 0)
        
        chartView.anchor(top: coinImageView.bottomAnchor, bottom: coinLabel.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 2, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
}
