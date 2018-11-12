//
//  SearchBarView.swift
//  Slash
//
//  Created by Michael Lema on 8/30/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "SearchCoins"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        return button
    }()
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let showAllLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "VIEW ALL COINS"
        label.font =  UIFont(name: "Avenir-Heavy", size: 30)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func setupViews() {
        addSubview(searchButton)
        addSubview(divider)
        addSubview(showAllLabel)
        
        searchButton.anchor(top: self.topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 15)
        divider.anchor(top: searchButton.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 6, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0.5)
        showAllLabel.anchor(top: divider.bottomAnchor, bottom: self.bottomAnchor, left: nil, right: self.rightAnchor, paddingTop: -3, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 75, height: 0)
    }
    
}
