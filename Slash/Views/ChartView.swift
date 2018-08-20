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

//class ChartView: LineChartView {
//    // MARK: - LineChartView
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//        setupNoData()
//        setupLeftAxis()
//        setupXAxis()
//
//
//        self.chartDescription?.enabled = false
//
//        self.dragEnabled = false
//        self.setScaleEnabled(false)
//        self.pinchZoomEnabled = false
//        self.highlightPerDragEnabled = true
//
//
//
//        self.legend.enabled = false
//
//        rightAxis.enabled = false
//        legend.enabled = false
//        isUserInteractionEnabled = false
//    }
//
//    // MARK: - Public
//
//    func setData(values: [ChartDataEntry]) {
//        let line = self.line(values: values)
//
//        let data = LineChartData()
//        data.addDataSet(line)
//
//        self.data = data
//    }
//
//    // MARK: - Private
//
//    private func line(values: [ChartDataEntry]) -> LineChartDataSet {
//        //: 1. color
//        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
//        set1.axisDependency = .left
//        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
//        set1.lineWidth = 1.5
//        set1.drawCirclesEnabled = false
//        set1.drawValuesEnabled = false
//        set1.fillAlpha = 0.26
//        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
//        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
//        set1.drawCircleHoleEnabled = false
//
//        let data = LineChartData(dataSet: set1)
//        data.setValueTextColor(.white)
//        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
//
//        return set1
//    }
//
//    private func setupNoData() {
//        //: 2. font
//        noDataFont = UIFont.systemFont(ofSize: 20)
//        noDataTextColor = UIColor.black
//        noDataText = "chart_view.no_data".localized
//    }
//
//    private func setupLeftAxis() {
//        let xAxis = self.xAxis
//        xAxis.labelPosition = .topInside
//        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
//        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
//        xAxis.drawAxisLineEnabled = false
//        xAxis.drawGridLinesEnabled = true
//        xAxis.centerAxisLabelsEnabled = true
//        xAxis.granularity = 3600
//        xAxis.valueFormatter = DateValueFormatter()
//    }
//
//    private func setupXAxis() {
//        let leftAxis = self.leftAxis
//        leftAxis.labelPosition = .insideChart
//        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
//        leftAxis.drawGridLinesEnabled = true
//        leftAxis.granularityEnabled = true
//        leftAxis.axisMinimum = 0
//        leftAxis.axisMaximum = 170
//        leftAxis.yOffset = -9
//        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
//
//
//        self.rightAxis.enabled = false
//        self.legend.form = .line
//
//
//    }
//
////    private func setupAxis(_ axis: AxisBase) {
////        //: 5 colors
////        axis.gridColor = UIColor.lightGray
////        axis.labelTextColor = UIColor.orange
////        axis.axisLineColor = UIColor.clear
////    }
//
//
//}
//
//
//public class DateValueFormatter: NSObject, IAxisValueFormatter {
//    private let dateFormatter = DateFormatter()
//
//    override init() {
//        super.init()
//        dateFormatter.dateFormat = "dd MMM HH:mm"
//    }
//
//    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
//    }
//}
//
