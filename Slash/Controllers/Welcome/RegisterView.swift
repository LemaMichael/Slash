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
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "NAME"
        label.font = UIFont(name: "Avenir-Medium", size: 13)
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
    
    var btcLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC AMOUNT"
        label.font = UIFont(name: "Avenir-Medium", size: 13)
        label.textAlignment = .left
        label.textColor = .orange
        return label
    }()
    var ethLabel: UILabel = {
        let label = UILabel()
        label.text = "ETH"
        label.font = UIFont(name: "Avenir-Medium", size: 13)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    var ltcLabel: UILabel = {
        let label = UILabel()
        label.text = "LTC"
        label.font = UIFont(name: "Avenir-Medium", size: 13)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    var bchLabel: UILabel = {
        let label = UILabel()
        label.text = "BCH"
        label.font = UIFont(name: "Avenir-Medium", size: 13)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    var etcLabel: UILabel = {
        let label = UILabel()
        label.text = "ETC"
        label.font = UIFont(name: "Avenir-Medium", size: 13)
        label.textAlignment = .right
        label.textColor = .lightGray
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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(btcLabel)
        stackView.addArrangedSubview(ethLabel)
        stackView.addArrangedSubview(ltcLabel)
        stackView.addArrangedSubview(bchLabel)
        stackView.addArrangedSubview(etcLabel)
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.black
        doneToolbar.isTranslucent = true
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneButtonAction))
        done.tintColor = .white
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.coinTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.coinTextField.resignFirstResponder()
    }
    
    func setupView() {
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(line)
        
        addSubview(stackView)
        addSubview(coinTextField)
        addSubview(line2)
        self.addDoneButtonOnKeyboard()

        //: Name
        nameLabel.anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 18, paddingRight: 0, width: 45, height: 25)
        nameTextField.anchor(top: self.nameLabel.bottomAnchor, bottom: nil, left: nameLabel.leftAnchor, right: self.rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 0, paddingRight: 20, width: 0, height: 25)
        line.anchor(top: nameTextField.bottomAnchor, bottom: nil, left: nameTextField.leftAnchor, right: nameTextField.rightAnchor, paddingTop: 2, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        
        //: BTC
        stackView.anchor(top: self.line.bottomAnchor, bottom: nil, left: self.nameLabel.leftAnchor, right: self.rightAnchor, paddingTop: 35, paddingBottom: 0, paddingLeft: 0, paddingRight: 18, width: 0, height: 25)
        coinTextField.anchor(top: self.btcLabel.bottomAnchor, bottom: nil, left: nameLabel.leftAnchor, right: self.rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 0, paddingRight: 20, width: 0, height: 25)
        line2.anchor(top: coinTextField.bottomAnchor, bottom: nil, left: nameTextField.leftAnchor, right: nameTextField.rightAnchor, paddingTop: 2, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        
    }
}



