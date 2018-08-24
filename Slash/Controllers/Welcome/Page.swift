//
//  Page.swift
//  Slash
//
//  Created by Michael Lema on 8/23/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class Page: UIViewController {
    
    var headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Black", size: 23)
        label.textAlignment = .center
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 222, green: 222, blue: 222)
        label.font = UIFont(name: "Avenir-Heavy", size: 12.5)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(headingLabel)
        self.view.addSubview(subLabel)
        self.view.backgroundColor = .clear
        
        let width = self.view.frame.width
        let viewWidth = (self.view.frame.width - 80)
        let diff = (width-viewWidth) / 2
        
        headingLabel.anchor(top: self.view.topAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 25)
        subLabel.anchor(top: headingLabel.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 4.5, paddingBottom: 0, paddingLeft: diff, paddingRight: diff, width: 0, height: 35)
    }
}
