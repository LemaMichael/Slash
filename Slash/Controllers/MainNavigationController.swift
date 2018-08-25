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
        
        if isLoggedIn() {
            perform(#selector(showHomeViewController), with: nil, afterDelay: 0.00) //0.70
        } else {
            let welcomeViewController = WelcomeViewController()
            viewControllers = [welcomeViewController]
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    //: MARK: - viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func showHomeViewController() {
        self.present(HomeViewController(), animated: false, completion: nil)
        //self.pushViewController(homeViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(true, animated: false)
    }
}
