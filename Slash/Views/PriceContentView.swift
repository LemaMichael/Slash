//
//  PriceContentView.swift
//  Slash
//
//  Created by Michael Lema on 8/26/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class PriceContentView: UIView {
    fileprivate let shadeGray = UIColor(red:0.61, green:0.65, blue:0.69, alpha:1.0)
    fileprivate let customRed = UIColor(red: 1, green: 0.451, blue: 0.447, alpha: 1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "$6,624.01"
        label.textColor = shadeGray
        let font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        label.textAlignment = .center
        label.font = font
        return label
    }()
    
    lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "-$9.00 (0.14%) this hour"
        label.textColor = customRed //: We'll have to change this color based on the price
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.7, alpha: 1)
        return view
    }()
    
    func setupViews() {
        addSubview(coinPriceLabel)
        addSubview(percentageLabel)
        addSubview(dividerView)
        coinPriceLabel.anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 54.6)
        percentageLabel.anchor(top: coinPriceLabel.bottomAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 22)
        dividerView.anchor(top: nil, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
    }
    
}
