//
//  CustomGrayButton.swift
//  Slash
//
//  Created by Michael Lema on 8/26/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class CustomGrayButton: UIButton {
    let customBackgroundColor = UIColor(red: 0.353, green: 0.451, blue: 0.522, alpha: 0.7)
    let customTintColor = UIColor(red: 0.353, green: 0.451, blue: 0.522, alpha: 1)
    let customfont = UIFont(name: "AvenirNext-DemiBold", size: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(customTintColor, for: .normal)
        self.titleLabel?.font = customfont
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
    }
    func defaultChosen() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = customBackgroundColor
    }
    
    func showTappedColor() {
        self.backgroundColor = customBackgroundColor
        self.setTitleColor(.white, for: .normal)
    }
    
    func defaultState() {
        self.backgroundColor = .clear
        self.setTitleColor(customTintColor, for: .normal)
    }
}
