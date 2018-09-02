//
//  DescriptionView.swift
//  Slash
//
//  Created by Michael Lema on 8/30/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class DescriptionView: UIView {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textColor = UIColor.rgb(red: 140, green: 135, blue: 137)
        tv.font = UIFont(name: "Avenir-Heavy", size: 11.4)
        tv.isEditable = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
        addSubview(textView)
        textView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
    }
}
