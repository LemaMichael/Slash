//
//  LTCController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class PortfolioController: UIViewController {
    
    lazy var pieView = PieView()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Portfolio"
        pieView.setData()
        pieView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)

        view.backgroundColor = UIColor.rgb(red: 40, green: 43, blue: 53)
        self.view.addSubview(pieView)
        setupViews()
    }
    
    func setupViews(){
        pieView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 300)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
