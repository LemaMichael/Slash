//
//  DetailContainerView.swift
//  Slash
//
//  Created by Michael Lema on 8/30/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class DetailContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 104, green: 100, blue: 106)
        return view
    }()
    let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 104, green: 100, blue: 106)
        return view
    }()
    
    //: Following two views will be above stackView
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //: No image place holder
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 28/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font =  UIFont(name: "Avenir-Heavy", size: 15)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.text = "$0.00"
        return label
    }()
    
    // Default Labels
    let marketCapLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Market Cap: "
        return label
    }()
    let volume24hLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Volume (24h): "
        label.textAlignment = .left
        return label
    }()
    let circulatingSupplyLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Circulating Supply: "
        label.textAlignment = .left
        return label
    }()
    let change24hLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Change (24h): "
        label.textAlignment = .left
        return label
    }()
    let high24hLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "High (24h): "
        label.textAlignment = .left
        return label
    }()
    let low24hLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Low (24h): "
        label.textAlignment = .left
        return label
    }()
    
    lazy var leftStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(marketCapLabel)
        sv.addArrangedSubview(volume24hLabel)
        sv.addArrangedSubview(circulatingSupplyLabel)
        sv.addArrangedSubview(change24hLabel)
        sv.addArrangedSubview(high24hLabel)
        sv.addArrangedSubview(low24hLabel)

        sv.distribution = .fillProportionally
        sv.axis = .vertical
        return sv
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(priceLabel)
        addSubview(topDivider)
        addSubview(leftStackView)
        addSubview(bottomDivider)
        
        imageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: -3, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 28, height: 28)
        priceLabel.anchor(top: topAnchor, bottom: nil, left: imageView.rightAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 30)
        
        topDivider.anchor(top: priceLabel.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDivider.anchor(top: nil, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        leftStackView.anchor(top: topDivider.bottomAnchor, bottom: bottomDivider.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
