//
//  DetailsView.swift
//  Slash
//
//  Created by Michael Lema on 9/1/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class DetailsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // Default Labels
    let startDateLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Start Date: "
        return label
    }()
    let totalSupplyLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Total Supply: "
        label.textAlignment = .left
        return label
    }()
    let algorithmLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Algorithm: "
        label.textAlignment = .left
        return label
    }()
    let proofLabel: DefaultLabel = {
        let label = DefaultLabel()
        label.text = "Proof Type: "
        label.textAlignment = .left
        return label
    }()
    
    lazy var leftStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(startDateLabel)
        sv.addArrangedSubview(totalSupplyLabel)
        sv.addArrangedSubview(algorithmLabel)
        sv.addArrangedSubview(proofLabel)
        
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        return sv
    }()
    
    
    func setupViews() {
        addSubview(topDivider)
        addSubview(leftStackView)
        addSubview(bottomDivider)
        
        topDivider.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDivider.anchor(top: nil, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        leftStackView.anchor(top: topDivider.bottomAnchor, bottom: bottomDivider.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
