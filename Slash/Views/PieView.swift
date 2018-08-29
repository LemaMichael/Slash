//
//  PieChartView.swift
//  Slash
//
//  Created by Michael Lema on 8/28/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import Charts

class PieView: PieChartView {
    fileprivate let colors: [UIColor] = [UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0),
                                         UIColor(red:0.21, green:0.27, blue:0.31, alpha:1.0),
                                         UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0),
                                         UIColor(red:0.95, green:0.47, blue:0.21, alpha:1.0),
                                         UIColor(red:0.35, green:0.55, blue:0.45, alpha:1.0)]
    
    
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

    }
    private func setupChart() {
        self.chartDescription?.text = ""
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.legend.enabled = false //: Removes dataSet label
        
        //:Demo
        self.usePercentValuesEnabled = true
        self.drawSlicesUnderHoleEnabled = false
        self.holeColor = .clear
        self.holeRadiusPercent = 0.78
        self.transparentCircleRadiusPercent = 0.8035
//        self.transparentCircleColor = .white
        self.chartDescription?.enabled = false
        self.setExtraOffsets(left: 12, top: 10, right: 12, bottom: 10)
        
        //: Center text
        self.drawCenterTextEnabled = true
        
        //: Demo
        self.drawHoleEnabled = true
        self.rotationAngle = 0
        self.rotationEnabled = true
        self.highlightPerTapEnabled = true
        
        self.entryLabelColor = .white
        self.entryLabelFont = UIFont(name: "Avenir-Heavy", size: 13)
        self.drawEntryLabelsEnabled = false //: Doesn't display the labels such as Bitcoin, Litecoin, etc.
    }
    
    func setData() {
        let coinName = ["Bitcoin", "Ethereum", "Litecoin", "Bitcoin Cash", "Ethereum Classic"]

        var coinPrices = [Double]()
        for name in coinName {
            let totalPrice = UserDefaults.standard.getTotalPrice(coin: name)
            if totalPrice != 0 {
                coinPrices.append(totalPrice)
            }
        }
        
        let entries = (0..<coinPrices.count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: coinPrices[i],
                                     label: coinName[i],
                                     icon: nil)
        }
        
        let set = PieChartDataSet(values: entries, label: nil)
        set.drawIconsEnabled = false
        set.sliceSpace = 3
        
        set.colors = colors
        
        set.valueLineColor = .white
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        set.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 2
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(UIFont(name: "Avenir-Heavy", size: 11))
        data.setValueTextColor(.white)
        
        self.data = data
        self.highlightValues(nil)
    }
}
