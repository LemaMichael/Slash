//
//  DataViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class BTCController: UIViewController {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis =  .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = CGFloat(10)
        stackView.alignment = .center
        return stackView
    }()
    
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "BTC")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let coinLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.textColor = .white
        label.font =  UIFont(name: "Avenir-Heavy", size: 40)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //: Yellow color
        view.backgroundColor = UIColor(red:0.91, green:0.73, blue:0.08, alpha:1.0)
        
        stackView.addArrangedSubview(coinImageView)
        stackView.addArrangedSubview(coinLabel)
        self.view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: (self.view.frame.width/2)).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


}

