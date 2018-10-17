//
//  BarView.swift
//  Slash
//
//  Created by Michael Lema on 8/29/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import Charts

class BarView: HorizontalBarChartView {
    fileprivate let colors: [UIColor] = [UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0),
                                         UIColor(red:0.21, green:0.27, blue:0.31, alpha:1.0),
                                         UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0),
                                         UIColor(red:0.95, green:0.47, blue:0.21, alpha:1.0),
                                         UIColor(red:0.35, green:0.55, blue:0.45, alpha:1.0),
                                         UIColor.black]
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNoData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupChart()
        setupAxis()
        setData()
        self.setNeedsDisplay()
    }
    
    private func setupNoData() {
        noDataFont = UIFont(name: "Avenir", size: 14)
        noDataTextColor = UIColor.white
        noDataText = "No data to show."
    }
    
    private func setupAxis() {
        //: Note the bar is horizontal, therefore the x-axis is the left y axis in the BarView
        let xAxis = self.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Avenir-Heavy", size: 11)!
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        
        let leftAxis = self.leftAxis
        leftAxis.labelFont = UIFont(name: "Avenir-Heavy", size: 11)!
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
        leftAxis.enabled = false
        
        let rightAxis = self.rightAxis
        rightAxis.enabled = false
        rightAxis.labelFont = UIFont(name: "Avenir-Heavy", size: 11)!
        rightAxis.labelTextColor = .white
        rightAxis.drawAxisLineEnabled = false
        rightAxis.axisMinimum = 0
        
        let l = self.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = true
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        self.legend.enabled = false
    }
    
    private func setupChart() {
        //: Interaction
        self.dragEnabled = false
        self.setScaleEnabled(false)
        self.pinchZoomEnabled = false
        self.highlightPerTapEnabled = false
        
        self.drawBarShadowEnabled = false
        self.drawValueAboveBarEnabled = true
        self.fitBars = true
        self.setExtraOffsets(left: -5, top: 10, right: 20, bottom: 12)
        
        self.chartDescription?.text = "Coin Amount"
        self.chartDescription?.font = UIFont(name: "Avenir-Heavy", size: 11.3)!
        self.chartDescription?.textColor = .white
        self.chartDescription?.textAlign = .right
    }
    
    func setData() {
        let user = UserDefaults.standard.getUser()
        let coinName = ["Bitcoin", "Ethereum", "Litecoin", "Bitcoin Cash", "Ethereum Classic", "0x"]
        
        var coinAmount = [Double]()
        for name in coinName {
            let totalPrice = user.getCoinBalance(coinName: name)
            if totalPrice != 0 {
                coinAmount.append(totalPrice)
            }
        }
        
        let entries = (0..<coinAmount.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i),
                                     y: coinAmount[i],
                                     icon: nil)
        }
        
        let set = BarChartDataSet(values: entries, label: "")
        set.drawValuesEnabled = true
        let formatter = DefaultValueFormatter.init(decimals: 2)
        set.valueFormatter = formatter
        
        set.colors = colors
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont(name: "Avenir-Heavy", size: 11))
        data.setValueTextColor(.white)
        //: Set the xAxis format
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: coinName)
        
        self.data = data
        self.highlightValues(nil)
    }
}
