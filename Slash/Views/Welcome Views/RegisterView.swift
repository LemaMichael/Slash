//
//  RegisterView.swift
//  Slash
//
//  Created by Michael Lema on 8/24/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class RegisterView: UIView {
    
    var coinAmounts = ["BTC AMOUNT", "ETH AMOUNT", "LTC AMOUNT", "BCH AMOUNT", "ETC AMOUNT"]
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "NAME"
        label.font = UIFont(name: "Avenir-Heavy", size: 13)
        label.textAlignment = .left
        label.textColor = .orange
        return label
    }()
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Avenir-Medium", size: 13)
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        return textField
    }()
    
    var line: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var line2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var coinLabel: UILabel = {
        let label = UILabel()
        label.text = coinAmounts[0]
        label.font = UIFont(name: "Avenir-Heavy", size: 13)
        label.textAlignment = .left
        label.textColor = .orange
        return label
    }()
   
    var coinTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Avenir-Medium", size: 13)
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.returnKeyType = .next
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateTextChange(forward: Bool) {
        let transition = CATransition()
        transition.duration = 0.6
        transition.type = kCATransitionPush
        transition.subtype = forward ? kCATransitionFromRight : kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.coinLabel.layer.add(transition, forKey: kCATransition)
    }
    
    func setupView() {
        //: Dismiss keyboard if user taps outside textfield
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:))))
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(line)
        
        addSubview(coinLabel)
        addSubview(coinTextField)
        addSubview(line2)

        //: Name
        nameLabel.anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 18, paddingRight: 0, width: 45, height: 25)
        nameTextField.anchor(top: self.nameLabel.bottomAnchor, bottom: nil, left: nameLabel.leftAnchor, right: self.rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 0, paddingRight: 20, width: 0, height: 25)
        line.anchor(top: nameTextField.bottomAnchor, bottom: nil, left: nameTextField.leftAnchor, right: nameTextField.rightAnchor, paddingTop: 2, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        
        //: BTC
        coinLabel.anchor(top: self.line.bottomAnchor, bottom: nil, left: self.nameLabel.leftAnchor, right: self.rightAnchor, paddingTop: 35, paddingBottom: 0, paddingLeft: 0, paddingRight: 18, width: 0, height: 25)
        coinTextField.anchor(top: self.coinLabel.bottomAnchor, bottom: nil, left: nameLabel.leftAnchor, right: self.rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 0, paddingRight: 20, width: 0, height: 25)
        line2.anchor(top: coinTextField.bottomAnchor, bottom: nil, left: nameTextField.leftAnchor, right: nameTextField.rightAnchor, paddingTop: 2, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        nameTextField.resignFirstResponder()
        coinTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.61, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = 0 
        }, completion: nil)
        return true
    }
}
