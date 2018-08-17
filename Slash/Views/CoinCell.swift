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
    
    let coinLabel: UILabel = {
        let label = UILabel()
        //label.text = "Bitcoin"
        label.textColor = .lightGray
        label.font =  UIFont(name: "Avenir", size: 30)
        label.textAlignment = .left
        //label.adjustsFontSizeToFitWidth = true
        //label.sizeToFit()
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
    
    
    func setupCell() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        addSubview(coinImageView)
        addSubview(coinLabel)
        addSubview(progressBar)
        addSubview(percentageLabel)
        
        percentageLabel.text =  String(format: "%.0f%%", progressBar.progressValue)
        coinImageView.anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 18, paddingBottom: 0, paddingLeft: 18, paddingRight: 0, width: 47, height: 47)
        coinLabel.anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 18, paddingRight: 0, width: 243, height: 70)
        progressBar.anchor(top: coinLabel.bottomAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 18, paddingRight: 40, width: 0, height: 6)
        percentageLabel.anchor(top: coinLabel.bottomAnchor, bottom: nil, left: progressBar.rightAnchor, right: self.rightAnchor, paddingTop: 1, paddingBottom: 0, paddingLeft: 4, paddingRight: 0, width: 0, height: 0)
    }
}
