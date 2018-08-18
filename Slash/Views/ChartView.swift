//
//  ChartView.swift
//  Slash
//
//  Created by Michael Lema on 8/17/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import Charts
import UIKit

class ChartView: LineChartView {
    // MARK: - LineChartView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupNoData()
        setupLeftAxis()
        setupXAxis()
        
        chartDescription?.enabled = false
        rightAxis.enabled = false
        legend.enabled = false
        isUserInteractionEnabled = false
    }
    
    // MARK: - Public
    
    func setData(values: [ChartDataEntry]) {
        let line = self.line(values: values)
        
        let data = LineChartData()
        data.addDataSet(line)
        
        self.data = data
    }
    
    // MARK: - Private
    
    private func line(values: [ChartDataEntry]) -> LineChartDataSet {
        //: 1. color
        let color = UIColor.orange
        let line = LineChartDataSet(values: values, label: nil)
        
        line.setColor(color)
        line.setCircleColor(color)
        line.lineWidth = 3
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        
        return line
    }
    
    private func setupNoData() {
        //: 2. font
        noDataFont = UIFont.systemFont(ofSize: 20)
        noDataTextColor = UIColor.black
         noDataText = "chart_view.no_data".localized
    }
    
    private func setupLeftAxis() {
        setupAxis(leftAxis)
        //: 4 font
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        
        leftAxis.valueFormatter = DefaultAxisValueFormatter.with(block: { value, _ -> String in
            return Float(value).toCurrencyString(fractionDigits: 0)
        })
    }
    
    private func setupXAxis() {
        setupAxis(xAxis)
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        
        xAxis.valueFormatter = DefaultAxisValueFormatter.with(block: { value, _ -> String in
            let dateFormat = "chart_view.date_format".localized
            return Date(timeIntervalSince1970: value).toString(dateFormat: dateFormat)
        })
        
    }
    
    private func setupAxis(_ axis: AxisBase) {
        //: 5 colors
        axis.gridColor = UIColor.lightGray
        axis.labelTextColor = UIColor.orange
        axis.axisLineColor = UIColor.clear
    }
    
    
}
