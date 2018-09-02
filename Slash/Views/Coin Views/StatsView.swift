//
//  StatsView.swift
//  Slash
//
//  Created by Michael Lema on 9/1/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class StatsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let highDefaultLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "HIGH"
        label.textAlignment = .center
        label.textColor = UIColor(red:0.49, green:0.59, blue:0.70, alpha:1.0)
        return label
    }()
    let lowDefaultLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "LOW"
        label.textAlignment = .center
        label.textColor = UIColor(red:0.49, green:0.59, blue:0.70, alpha:1.0)
        return label
    }()
    let changeDefaultLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "CHANGE"
        label.textAlignment = .center
        label.textColor = UIColor(red:0.49, green:0.59, blue:0.70, alpha:1.0)
        return label
    }()
    
    lazy var topStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(highDefaultLabel)
        sv.addArrangedSubview(lowDefaultLabel)
        sv.addArrangedSubview(changeDefaultLabel)
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    let highLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "$"
        label.textAlignment = .center
        return label
    }()
    let lowLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "$"
        label.textAlignment = .center
        return label
    }()
    let changeLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "%"
        label.textAlignment = .center
        return label
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(highLabel)
        sv.addArrangedSubview(lowLabel)
        sv.addArrangedSubview(changeLabel)
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var containerStack: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(topStackView)
        sv.addArrangedSubview(bottomStackView)
        sv.distribution = .fillEqually
        sv.axis = .vertical
        return sv
    }()
    
    func setupViews() {
        addSubview(containerStack)
        containerStack.anchor(top: nil, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        
        containerStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerStack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15).isActive = true
    }

}
