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
    
    let addTextField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = false
        textField.isUserInteractionEnabled = false
        textField.layer.masksToBounds = true
        //: Making my own border
        textField.layer.cornerRadius = 14
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.rgb(red: 227, green: 208, blue: 239).cgColor
        textField.font = UIFont(name: "Avenir-Heavy", size: 13)
        textField.textColor = UIColor.rgb(red: 140, green: 71, blue: 191)
        textField.textAlignment = .center
        textField.text = "Add"
        //textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //: https://github.com/gordoneliel/LinearProgressBar
    let progressBar: LinearProgressBar = {
        let pB = LinearProgressBar()
        pB.backgroundColor = .clear
        pB.barColor = .orange
        pB.trackColor = .lightGray
        //pB.barThickness = CGFloat(5)
        pB.progressValue = CGFloat(66)
        pB.trackPadding = 25
        
        return pB
    }()
    
    func setupCell() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        addSubview(coinImageView)
        addSubview(coinLabel)
        addSubview(progressBar)
        
        coinImageView.anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 18, paddingBottom: 0, paddingLeft: 18, paddingRight: 0, width: 47, height: 47)
        coinLabel.anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 18, paddingRight: 0, width: 243, height: 70)
        
        progressBar.anchor(top: coinLabel.bottomAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 18, paddingRight: 18, width: 0, height: 6)
    }
}
