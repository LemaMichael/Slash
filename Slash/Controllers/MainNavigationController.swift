//
//  MainNavigationController.swift
//  Slash
//
//  Created by Michael Lema on 8/24/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    //: TODO: Do something with this.
    let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Loading Screen")
        backgroundImage.contentMode = .scaleAspectFit
        return backgroundImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.insertSubview(backgroundImage, at: 0)
        
        //: For testing
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        //UserDefaults.standard.synchronize()
        if isLoggedIn() {
            self.pushViewController(HomeViewController(), animated: false)
            //perform(#selector(showHomeViewController), with: nil, afterDelay: 0.00) //0.70
        } else {
            let welcomeViewController = WelcomeViewController()
            viewControllers = [welcomeViewController]
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showHomeViewController() {
        self.pushViewController(HomeViewController(), animated: false)
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
