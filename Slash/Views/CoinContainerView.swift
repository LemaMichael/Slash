//
//  CoinContainerView.swift
//  Slash
//
//  Created by Michael Lema on 8/30/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class CoinContainerView: UIView {
    
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
    
    let symbolLeftLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Symbol"
        return label
    }()
    let nameLeftLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Name"
        return label
    }()
    lazy var leftStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(symbolLeftLabel)
        sv.addArrangedSubview(nameLeftLabel)
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        return sv
    }()
    let symbolLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.textAlignment = .right
        return label
    }()
    let nameLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.textAlignment = .right
        return label
    }()
    
    lazy var rightStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(symbolLabel)
        sv.addArrangedSubview(nameLabel)
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        return sv
    }()
    
    
    func setupViews() {
        addSubview(topDivider)
        addSubview(leftStackView)
        addSubview(rightStackView)
        addSubview(bottomDivider)
        
        topDivider.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDivider.anchor(top: nil, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        let customWidth = self.frame.width / 2
        leftStackView.anchor(top: topDivider.bottomAnchor, bottom: bottomDivider.topAnchor, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: customWidth, height: 0)
        rightStackView.anchor(top: topDivider.bottomAnchor, bottom: bottomDivider.topAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: customWidth, height: 0)
    }
    
}

class DefaultLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        self.textColor = .white
        self.font = UIFont(name: "Avenir-Heavy", size: 12)
        self.textAlignment = .left
        self.adjustsFontSizeToFitWidth = true
    }
}
