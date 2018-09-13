//
//  File.swift
//  Slash
//
//  Created by Michael Lema on 8/18/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var name = String()
    var btcAmount = 0.0, ethAmount = 0.0, ltcAmount = 0.0, bchAmount = 0.0, etcAmount = 0.0
    var prevButtonItem = UIBarButtonItem()
    
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
        view.isHidden = true
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
        // https://stackoverflow.com/questions/37722323/how-to-present-view-controller-from-right-to-left-in-ios-using-swift
        let transition = CATransition()
        transition.duration = 0.6
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.registerView.layer.add(transition, forKey: kCATransition)
        self.registerView.isHidden = false
        self.registerView.alpha = 1
        self.registerView.nameTextField.becomeFirstResponder()
    }
    
    @objc func nextButtonAction() {
        let textField: UITextField = self.registerView.coinTextField
        let coinLabel: UILabel = self.registerView.coinLabel
        
        guard let coinText = coinLabel.text else {return}
        //: I rather get the substring "BTC" instead of "BTC AMOUNT"
        let start = coinText.startIndex
        let end = coinText.index(start, offsetBy: 3)
        let range = start..<end
        let currentCoin = coinText[range]
        
        guard let inputText = textField.text else { return }
        let doubleVal = Double(inputText) ?? 0.0
        let invalidInput: Bool = (inputText.isEmpty || doubleVal == 0.0)
        
        switch currentCoin {
        case "BTC":
            btcAmount = invalidInput ? 0.0 : doubleVal
            //: Clear out
            textField.text = ""
            //: change Label text
            self.registerView.animateTextChange(forward: true)
            coinLabel.text = self.registerView.coinAmounts[1]
            prevButtonItem.isEnabled = true
            prevButtonItem.tintColor = .white
            
        case "ETH":
            ethAmount = invalidInput ? 0.0 : doubleVal
            textField.text = ""
            self.registerView.animateTextChange(forward: true)
            coinLabel.text = self.registerView.coinAmounts[2]
        case "LTC":
            ltcAmount = invalidInput ? 0.0 : doubleVal
            textField.text = ""
            self.registerView.animateTextChange(forward: true)
            coinLabel.text = self.registerView.coinAmounts[3]
        case "BCH":
            bchAmount = invalidInput ? 0.0 : doubleVal
            textField.text = ""
            self.registerView.animateTextChange(forward: true)
            coinLabel.text = self.registerView.coinAmounts[4]
        case "ETC":
            textField.resignFirstResponder()
            etcAmount = invalidInput ? 0.0 : doubleVal
            _ = User(name: name, btcBalance: btcAmount, ethBalance: ethAmount, ltcBalance: ltcAmount, bchBalance: bchAmount, etcBlance: etcAmount)
            UserDefaults.standard.setIsLoggedIn(value: true)
            self.navigationController?.pushViewController(HomeViewController(), animated: false)
        default:
            textField.resignFirstResponder()
        }
    }
    
    @objc func prevButtonAction() {
        let textField: UITextField = self.registerView.coinTextField

        let coinLabel: UILabel = self.registerView.coinLabel
        guard let coinText = coinLabel.text else {return}
        //: I rather get the substring "BTC" instead of "BTC AMOUNT"
        let start = coinText.startIndex
        let end = coinText.index(start, offsetBy: 3)
        let range = start..<end
        let currentCoin = coinText[range]
        
        switch currentCoin {
        case "ETH":
            textField.text = ""
            self.registerView.animateTextChange(forward: false)
            coinLabel.text = self.registerView.coinAmounts[0]
            prevButtonItem.isEnabled = false
            prevButtonItem.tintColor = .clear
        case "LTC":
            textField.text = ""
            self.registerView.animateTextChange(forward: false)
            coinLabel.text = self.registerView.coinAmounts[1]
        case "BCH":
            textField.text = ""
            self.registerView.animateTextChange(forward: false)
            coinLabel.text = self.registerView.coinAmounts[2]
        case "ETC":
            textField.text = ""
            self.registerView.animateTextChange(forward: false)
            coinLabel.text = self.registerView.coinAmounts[3]
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(startButton)
        self.view.addSubview(registerView)
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        //: Textfield
        self.addButtonsOnKeyboard()
        self.registerView.nameTextField.delegate = self
        self.registerView.coinTextField.delegate = self
        
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
    
    func addButtonsOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.barStyle = UIBarStyle.black
        doneToolbar.isTranslucent = true
        
        prevButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(prevButtonAction))
        prevButtonItem.isEnabled = false
        prevButtonItem.tintColor = .clear
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonAction))
        nextButtonItem.tintColor = .white
        
        var items = [UIBarButtonItem]()
        items.append(prevButtonItem)
        items.append(flexSpace)
        items.append(nextButtonItem)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.registerView.coinTextField.inputAccessoryView = doneToolbar
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

//: MARK: - UITextFieldDelegate
extension WelcomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.registerView.nameTextField {
        } else if textField == self.registerView.coinTextField {
        }
        return true
    }
    
    //: Use this method to validate the current text
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.registerView.nameTextField {
            if let validName = self.registerView.nameTextField.text { name = validName }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.registerView.coinTextField.becomeFirstResponder()
        if let validName = self.registerView.nameTextField.text { name = validName }
        return true
    }
}
