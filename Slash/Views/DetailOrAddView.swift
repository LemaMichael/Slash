//
//  DetailOrAddView.swift
//  Slash
//
//  Created by Michael Lema on 8/30/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class DetailOrAddView: UIView {
    
    let detailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Details", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 12)
        //: Adjust button
        button.backgroundColor = .clear
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2.2, bottom: 0, right: 2.2)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.rgb(red: 16, green: 43, blue: 46), for: .normal)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 12)
        //: Adjust button
        button.layer.cornerRadius = 3
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(detailButton)
        sv.addArrangedSubview(addButton)
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.axis = .horizontal
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(stackView)
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}

