//
//  CoinCell.swift
//  Slash
//
//  Created by Michael Lema on 8/17/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CoinCell: UICollectionViewCell {
    
    
    var coin: CoinDetail?
    
    let green = UIColor(red:0.38, green:0.79, blue:0.00, alpha:1.0)
    let red = UIColor(red:1.00, green:0.29, blue:0.29, alpha:1.0)
    
    var pairID: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //: From Barbar macOS app - Dai Hovey
    func update(_ coin: CoinDetail) {
        DispatchQueue.main.async {
            //guard let pairID = pairID else { return }
            guard let price = coin.currentPrice else {
                self.coinPrice.text = "$0.00"
                self.coinPercentage.text = "..."
                return
            }
            self.coinPrice.text = "$\(price)" //: FIXME: Find a better way to do this
            guard let pair = coin.id else {
                self.coinLabel.text = "Loading..."
                return
            }
            if let currencyPair = coin.id {
                self.coinLabel.text = coin.officialName()
            }
            self.coinImageView.image = UIImage(named: coin.imageName())?.withRenderingMode(.alwaysTemplate)
            
            let percentString = "\(CurrencyFormatter.sharedInstance.percentFormatter.string(from: NSNumber(value: coin.percent()))!)%"
            
            let diffString = "\(coin.difference())"
            
            let options = CurrencyFormatterOptions()
            options.showPositivePrefix = true
            options.showNegativePrefix = true
            
            self.coinPercentage.text = "\(CurrencyFormatter.sharedInstance.formatAmountString(diffString, currency: "USD", options: options))  \(percentString)"
            
            if coin.difference() < 0 {
                self.coinPercentage.textColor = self.red
            } else {
                self.coinPercentage.textColor = self.green
            }
        }
    }
    
    func updateOffline() {
        DispatchQueue.main.async {
            // self.coinPrice.text = "Sorry, can't connect"
            self.coinPercentage.text = "Sorry, can't connect."
            self.coinPercentage.textColor = self.red
        }
    }
    
    
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
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
    
    let intervalButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("24h", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 10)
        button.titleLabel?.textColor = .white
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor(red:0.85, green:0.88, blue:0.91, alpha:1.0) //: Light gray color
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var progressView: UIProgressView = {
        let pV = UIProgressView()
        pV.progress = Float(0.00)
        //pV.progressTintColor = .orange
        pV.trackTintColor = UIColor(white: 0.80, alpha: 0.75)
        //: For the track view to be round
        pV.layer.masksToBounds = true
        pV.layer.cornerRadius = 2.5
        
        //: For the progress view to be round
        pV.layer.sublayers![1].cornerRadius = 2.5
        pV.subviews[1].clipsToBounds = true
        return pV
    }()
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        return label
    }()
    
    lazy var chartView: LineChartView = {
        let cv = LineChartView()
        cv.chartDescription?.text = ""
        cv.backgroundColor = .white
        cv.isUserInteractionEnabled = false
        cv.legend.enabled = false //: Remove dataSet label
        cv.dragEnabled = false
        cv.setScaleEnabled(false)
        cv.pinchZoomEnabled = false
        cv.highlightPerDragEnabled = false
        return cv
    }()
    
    
    func setupProgressBarAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressView.layoutIfNeeded()
            self.progressView.setProgress(0.66, animated: true)
            self.percentageLabel.text = String(format: "%.0f%%", self.progressView.progress * 100)
        }
    }
    
    
    //: Add this back if you want tp display the hours at the bottom
    func setxAxis() {
        let xAxis = chartView.xAxis
        //        xAxis.labelPosition = .bottom
        //        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        //        xAxis.labelTextColor = UIColor.red
        //        xAxis.drawAxisLineEnabled = false //: The bottom axis isn't needed
        //        xAxis.drawGridLinesEnabled = false //: Grid isn't needed either
        //        xAxis.centerAxisLabelsEnabled = true
        //        xAxis.granularity = 3600 // 60*60 one hour
        //        xAxis.valueFormatter = DateValueFormatter()
        xAxis.enabled = false //: CHANGE
    }
    
    
    //: Add this back if you want to display the coin price on the left side of the chart
    func setLeftAxis() {
        //This displays the price at the left of the chart
        /*
         self.chartView.leftAxis.enabled = true
         self.chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.with(block: { value, _ -> String in
         return Float(value).toCurrencyString(fractionDigits: 2)
         }) */
        self.chartView.leftAxis.enabled = false
        
    }
    func setRightAxis() {
        self.chartView.rightAxis.enabled = false
    }
    
    func setChartData(values: [ChartDataEntry], lineColor: UIColor) {
        
        let line = self.line(values: values, lineColor: lineColor)
        
        let data = LineChartData()
        data.addDataSet(line)
        self.chartView.data = data
        
    }
    
    private func line(values: [ChartDataEntry], lineColor: UIColor) -> LineChartDataSet {
        //: 1. color
        let set1 = LineChartDataSet(values: values, label: nil)
        set1.mode = .cubicBezier //: Change this back to linear for default chart
        // set1.axisDependency = .left
        set1.setColor(lineColor, alpha: 1.00)
        set1.setCircleColor(lineColor)
        set1.lineWidth = 3.3
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        //: FIXME: Find some colors to mix with.
        let gradientColors = [lineColor.cgColor,
                              lineColor.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 0.35
        set1.fill = Fill(linearGradient: gradient, angle: 0)
        set1.drawFilledEnabled = false //: If true this will draw more than the surface
        set1.drawCircleHoleEnabled = false

        //        let data = LineChartData(dataSet: set1)
        //        data.setValueTextColor(.white)
        //        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        //        chartView.data = data
        //        data.setValueTextColor(.white)
        //        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        return set1
    }
    
    
    func setupCell() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        addSubview(coinImageView)
        addSubview(coinPrice)
        addSubview(coinPercentage)
        addSubview(coinLabel)
        addSubview(intervalButton)
        addSubview(progressView)
        addSubview(percentageLabel)
        addSubview(chartView)
        
        setupProgressBarAnimation()
        setxAxis()
        setLeftAxis()
        setRightAxis()
        
        percentageLabel.text = String(format: "%.0f%%", progressView.progress * 100)
        
        coinImageView.anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 18, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 47, height: 47)
        coinPrice.anchor(top: self.topAnchor, bottom: chartView.topAnchor, left: self.coinImageView.rightAnchor, right: nil, paddingTop: 18, paddingBottom: 0, paddingLeft: 2, paddingRight: 0, width: 125, height: 0)
        coinPercentage.anchor(top: self.topAnchor, bottom: chartView.topAnchor, left: self.coinPrice.rightAnchor, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: -5, paddingRight: 18, width: 75, height: 0)
        
        coinLabel.anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 18, paddingRight: 0, width: 243, height: 70)
        progressView.anchor(top: coinLabel.bottomAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 18, paddingRight: 40, width: 0, height: 6)
        percentageLabel.anchor(top: coinLabel.bottomAnchor, bottom: nil, left: progressView.rightAnchor, right: self.rightAnchor, paddingTop: 1, paddingBottom: 0, paddingLeft: 4, paddingRight: 0, width: 0, height: 0)
        
        chartView.anchor(top: coinImageView.bottomAnchor, bottom: coinLabel.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 2, paddingBottom: 12, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        intervalButton.anchor(top: self.chartView.bottomAnchor, bottom: nil, left: nil, right: self.rightAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 0, paddingRight: 18, width: 25, height: 21)

        
        
        //        //: Setting up coin
        //        guard let coin = coin else { return }
        //        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        //        coinImageView.image = UIImage(named: coin.id)
        //        coinPrice.text = coin.currentPrice
        //        coinPercentage.text = coin.currentPrice
        //        coinLabel.text = coin.name
        
    }
}


public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        //dateFormatter.dateFormat = "dd MMM HH:mm"
        dateFormatter.dateFormat = "HH"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

