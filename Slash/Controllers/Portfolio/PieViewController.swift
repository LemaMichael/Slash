//
//  BTHController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import Charts

class PieViewController: UIViewController {
    lazy var pieView = PieView()

    override func viewDidLoad() {
        super.viewDidLoad()
        pieView.delegate = self
        pieView.setData()
        pieView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        self.view.addSubview(pieView)
        setupView()
    }
    
    func setupView() {
      pieView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -20, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//: MARK - ChartViewDelegate
extension PieViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataEntry = entry as? PieChartDataEntry else { return }
        guard let validText = dataEntry.label else { return }
        let formatPrice = CurrencyFormatter.sharedInstance.formatAmount(entry.y, currency: "USD", options: nil)
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "\(formatPrice)\n\(validText)")
        centerText.setAttributes([.font: UIFont(name: "Avenir-Heavy", size: 13)!,
                                  .paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: centerText.length))
        pieView.centerAttributedText = centerText
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        pieView.centerAttributedText = nil
    }
}
