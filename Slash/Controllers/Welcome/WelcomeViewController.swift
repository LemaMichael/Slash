//
//  File.swift
//  Slash
//
//  Created by Michael Lema on 8/18/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    let orangeColor = UIColor(red:1.00, green:0.37, blue:0.23, alpha:1.0)
    let blueColor = UIColor(red:0.12, green:0.17, blue:0.23, alpha:1.0) //: Dark blue
    let darkRed = UIColor(red:0.86, green:0.13, blue:0.22, alpha:1.0)
    
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Black", size: 30)
        label.text = "Slash"
        label.textAlignment = .center
        return label
    }()
    
    let registerView: RegisterView = {
        let view = RegisterView()
        view.backgroundColor = .clear
        view.isHidden = false
        return view
    }()
    
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 22)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    let pageViewController: PageViewController = {
        let pvc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pvc.view.translatesAutoresizingMaskIntoConstraints = false
        pvc.view.backgroundColor = .clear
        return pvc
    }()
    
    @objc func startTapped() {
        print("Start Button tapped")
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
//            self.startButton.isHidden = true
            self.registerView.isHidden = false
        })

        
    }
    
    override func viewDidLoad() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(startButton)
        self.view.addSubview(registerView)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        
        let height = self.view.bounds.height
        let viewHeight = (height - 100)
        let diff = (height - viewHeight)  / 2
        titleLabel.anchor(top: self.view.topAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: diff, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        
        
        registerView.anchor(top: nil, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: self.view.bounds.height / 2)
        registerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        registerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        imageView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        startButton.anchor(top: nil, bottom: self.view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: -30, paddingLeft: 0, paddingRight: 0, width: 200, height: 0)
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        pageViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -40).isActive = true
        pageViewController.view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        pageViewController.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    //: MARK: - viewWillAppear & viewWillDisappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}


