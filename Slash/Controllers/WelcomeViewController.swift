//
//  File.swift
//  Slash
//
//  Created by Michael Lema on 8/18/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import UIKit
import GDAXSocketSwift

class WelcomeViewController: UIViewController {
    let orangeColor = UIColor(red:1.00, green:0.37, blue:0.23, alpha:1.0)
    let blueColor = UIColor(red:0.12, green:0.17, blue:0.23, alpha:1.0) //: Dark blue

    fileprivate let colors: [UIColor] = [UIColor(red:0.91, green:0.73, blue:0.08, alpha:1.0),
                                         UIColor(red:0.21, green:0.27, blue:0.31, alpha:1.0),
                                         UIColor(red:0.35, green:0.42, blue:0.38, alpha:1.0),
                                         UIColor(red:0.95, green:0.47, blue:0.21, alpha:1.0),
                                         UIColor(red:0.35, green:0.55, blue:0.45, alpha:1.0)]

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "Welcome")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        
        imageView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
}


