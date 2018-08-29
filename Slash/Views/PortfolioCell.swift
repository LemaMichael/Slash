//
//  PortfolioCell.swift
//  Slash
//
//  Created by Michael Lema on 8/29/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class PortfolioCell: UICollectionViewCell {
    let customRed = UIColor(red:0.94, green:0.31, blue:0.11, alpha:1.0)
    let customGreen = UIColor(red:0.27, green:0.75, blue:0.14, alpha:1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "BCH")
        return imageView
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.text = "Bitcoin"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let holdingButton: UIButton = {
        let button = UIButton(type: .system)
        let color = UIColor.rgb(red: 134, green: 134, blue: 145)
        button.setTitleColor(color, for: .normal)
        button.setTitle("1.00", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font =  UIFont(name: "Avenir-Heavy", size: 13)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let totalValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "$5,650.05"
        label.textAlignment = .right
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var gainLossLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.customGreen
        label.font = UIFont(name: "Avenir-Heavy", size:13)
        label.text = "+ $20.25"
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var leftStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(nameLabel)
        sv.addArrangedSubview(holdingButton)
        sv.distribution = .fillProportionally
        sv.spacing = 3
        sv.axis = .vertical
        return sv
    }()
    
    lazy var rightStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(totalValueLabel)
        sv.addArrangedSubview(gainLossLabel)
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        return sv
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 47, green: 47, blue: 64)
        return view
    }()
    
    
    func setupCell() {
        addSubview(imageView)
        addSubview(leftStackView)
        addSubview(rightStackView)
        addSubview(divider)
    
      
        imageView.anchor(top: nil, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 18, paddingRight: 0, width: 40, height: 40)
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let width = self.bounds.width
        let adjustedWidth = width - imageView.bounds.width - 51  //: 51 comes from the imageView and leftStackView & rightStackView padding
        let splitWidth = (adjustedWidth / 2) - 30
        
        leftStackView.anchor(top: nil, bottom: nil, left: imageView.rightAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: splitWidth, height: 35)
        leftStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        rightStackView.anchor(top: nil, bottom: nil, left: nil, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 18, width: splitWidth, height: 40)
        rightStackView.centerYAnchor.constraint(equalTo: self.leftStackView.centerYAnchor).isActive = true
        
        divider.anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 18, paddingRight: 18, width: 0, height: 1)
    }
}
