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
    let imageView: UIImageView = {
        let imageView = UIImageView()
        let welcomeImage = #imageLiteral(resourceName: "Welcome")
        imageView.image = welcomeImage
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let pageViewController: PageViewController = {
        let pvc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pvc.view.translatesAutoresizingMaskIntoConstraints = false
        pvc.view.backgroundColor = .clear
        return pvc
    }()
    
    
    override func viewDidLoad() {
        self.view.addSubview(imageView)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        imageView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)

        pageViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageViewController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        pageViewController.view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        pageViewController.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}


