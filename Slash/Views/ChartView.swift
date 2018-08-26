//
//  ChartView.swift
//  Slash
//
//  Created by Michael Lema on 8/26/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import Charts

class ChartView: LineChartView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNoData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupChart()
        setupAxis()
    }
    
    private func setupNoData() {
        noDataFont = UIFont(name: "Avenir", size: 14)
        noDataTextColor = UIColor.white
        noDataText = "No data to show."
    }
    
    private func setupAxis() {
        self.leftAxis.enabled = false
        self.rightAxis.enabled = false
        let xAxis = self.xAxis
        xAxis.enabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "AvenirNext-Regular", size: 10)!
        self.extraBottomOffset = 3 //: Extra spacing for the label font to fit
        
        xAxis.labelTextColor = UIColor(red: 0.678, green: 0.725, blue: 0.776, alpha: 1)
        xAxis.drawAxisLineEnabled = false //: The bottom axis isn't needed
        xAxis.drawGridLinesEnabled = false //: Grid isn't needed either
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600 // 60*60 one hour
        xAxis.valueFormatter = DateValueFormatter()
    }
    private func setupChart() {
        self.chartDescription?.text = ""
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.legend.enabled = false //: Removes dataSet label
        
        //: Interaction
        self.dragEnabled = true
        self.setScaleEnabled(false) 
        self.pinchZoomEnabled = false
        self.highlightPerDragEnabled = true
        
//        self.drawGridBackgroundEnabled = true
//        self.gridBackgroundColor = .clear
        self.highlightPerDragEnabled = true
    }
    
    func setData(values: [ChartDataEntry], lineColor: UIColor) {
        
        let line = self.line(values: values, lineColor: lineColor)
        
        let data = LineChartData()
        data.addDataSet(line)
        self.data = data
  
    }
    private func line(values: [ChartDataEntry], lineColor: UIColor) -> LineChartDataSet {
        //: 1. color
        let dataSet = LineChartDataSet(values: values, label: nil)
        dataSet.mode = .cubicBezier //: Change this back to linear for default chart
        // set1.axisDependency = .left
        dataSet.setColor(lineColor, alpha: 1.00)
        dataSet.setCircleColor(lineColor)
        dataSet.lineWidth = 3.3
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        //: FIXME: Find some colors to mix with.
        let gradientColors = [lineColor.cgColor,
                              lineColor.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 0.35
        dataSet.fill = Fill(linearGradient: gradient, angle: 0)
        dataSet.drawFilledEnabled = true //: If true this will draw more than the surface
        dataSet.drawCircleHoleEnabled = true
        
        dataSet.drawHorizontalHighlightIndicatorEnabled = false //: Display only the vertical indicator
        dataSet.highlightColor = lineColor
        return dataSet
    }
}
