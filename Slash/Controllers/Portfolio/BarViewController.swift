//
//  BarViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/29/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//
import UIKit
import Charts

class BarViewController: UIViewController {
    lazy var barView = BarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barView.delegate = self
        barView.setData()
        barView.animate(yAxisDuration: 2.5)
        barView.chartDescription?.textAlign = .center

        //: Sets the description text to be on the top center of the view
        //let middle = (view.frame.width / 2) + 5
        //barView.chartDescription?.position = CGPoint(x: middle, y: 15)
        self.view.addSubview(barView)
        setupView()
    }
    
    func setupView() {
        barView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -20, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//: MARK - ChartViewDelegate
extension BarViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
    }
}
