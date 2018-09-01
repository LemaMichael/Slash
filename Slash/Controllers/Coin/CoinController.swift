//
//  DataViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import Charts
import SwiftEntryKit


class CoinController: DataController {
    
    let user = UserDefaults.standard.getUser()
    let priceContentView = PriceContentView()
    var coin = CoinDetail()
    lazy var chartView = ChartView()
    fileprivate var buttonArray = [CustomGrayButton]()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = CGFloat(12)
        return stackView
    }()
    lazy var button1: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1H", for: .normal)
        return button
    }()
    lazy var button2: CustomGrayButton = {
        let button = CustomGrayButton()
        button.defaultChosen() //: 1D button should show it is tapped by default
        button.setTitle("1D", for: .normal)
        return button
    }()
    lazy var button3: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1W", for: .normal)
        return button
    }()
    lazy var button4: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1M", for: .normal)
        return button
    }()
    lazy var button5: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("1Y", for: .normal)
        return button
    }()
    lazy var button6: CustomGrayButton = {
        let button = CustomGrayButton()
        button.setTitle("All", for: .normal)
        return button
    }()
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    //:TODO- Change font and color
    lazy var accountHolding: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        let title = "Your " + coin.officialName() + " value: \(user.getCoinBalance(coinName: coin.officialName()))"
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(displayCoinValue), for: .touchUpInside)
        return button
    }()
    //:TODO- Change font and color
    lazy var coinDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = coin.description(coinName: coin.officialName())
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Medium", size: 12.2)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    func setupButtons() {
        buttonArray = [button1, button2, button3, button4, button5, button6]
        buttonArray.forEach({ $0.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside) })
    }
    
    @objc func buttonTapped(sender: CustomGrayButton) {
        buttonArray.forEach({$0.defaultState()})
        sender.showTappedColor()
        
        guard let rangeText = sender.titleLabel?.text else {
            return
        }
        
        self.getHistoricData(coinID: coin.id, selectedRange: rangeText)
        
        //: Is this the best way to do this? Without this, the chartDataEntry was incomplete.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newData = self.chartDataEntry.reversed() as [ChartDataEntry]
            self.chartView.setData(values: newData)
        }
    }
    
    @objc func displayCoinValue() {
        accountHolding.isSelected = !accountHolding.isSelected
        if accountHolding.isSelected {
            //let currentPrice = user.getCoinPrice(coinName: coin.officialName())
            //let holdingAmount = user.getCoinBalance(coinName: coin.officialName())
            let totalPrice = UserDefaults.standard.getTotalPrice(coin: coin.officialName())
            let priceFormat = CurrencyFormatter.sharedInstance.formatAmount(totalPrice, currency: "USD", options:nil)
            let title = "Your " + coin.officialName() + " value: \(priceFormat)"
            accountHolding.setTitle(title, for: .normal)
        } else {
            let title = "Your " + coin.officialName() + " value: \(user.getCoinBalance(coinName: coin.officialName()))"
            accountHolding.setTitle(title, for: .normal)
        }
    }
    
    func formatPrice(value: Double, isScrolling: Bool) {
        //: Modify the percentLabel, ex: -$1,172.30 (14.90%)
        var difference = 0.0, percent = 0.00
        let options = CurrencyFormatterOptions()
        options.showPositivePrefix = true
        options.showNegativePrefix = true
        
        difference = isScrolling ? coin.difference(to: value) : coin.difference()
        percent = isScrolling ? coin.percent(to: value) : coin.percent()
        
        let percentStr = String(format: "  (%.2f%%)", percent)
        priceContentView.percentageLabel.text = CurrencyFormatter.sharedInstance.formatAmount(difference, currency: "USD", options: options) + percentStr
        if !isScrolling { priceContentView.percentageLabel.text! += " today"} //: FIXME- Will be different depending on the time frame
        priceContentView.percentageLabel.textColor = (difference < 0) ? priceContentView.customRed : priceContentView.customGreen
    }
    
    //: MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.01, green:0.14, blue:0.28, alpha:1.0)
        self.navigationItem.title = coin.officialName() + " Price"
        self.priceContentView.coinPriceLabel.text = CurrencyFormatter.sharedInstance.formatAmount(coin.validCurrentPrice(), currency: "USD", options: nil)
        formatPrice(value: 0.0, isScrolling: false)
        
        chartView.delegate = self
        chartView.xAxis.labelFont = UIFont(name: "AvenirNext-Regular", size: 11)!
        
        self.view.addSubview(priceContentView)
        self.view.addSubview(chartView)
        self.view.addSubview(stackView)
        self.view.addSubview(dividerView)
        self.view.addSubview(accountHolding)
        self.view.addSubview(containerView)
        containerView.addSubview(coinDescription)
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        stackView.addArrangedSubview(button4)
        stackView.addArrangedSubview(button5)
        stackView.addArrangedSubview(button6)
        
        setupButtons()
        setupConstraints()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Add"), style: .plain, target: self, action:  #selector(modifyCoins))
    }
    
    @objc func modifyCoins() {
        let alertController = UIAlertController(title: "\(coin.officialName()) Amount", message: "Enter size", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.textAlignment = .center
            textField.placeholder = "\(self.user.getCoinBalance(coinName: self.coin.officialName()))"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            let textField = alertController.textFields![0] as UITextField
            let newAmount = textField.text!
            var newInput = 0.0
            if !newAmount.isEmpty {
                //: Save the coin input amount
                if let newValue = Double(newAmount) {
                    newInput = newValue
                    UserDefaults.standard.setCoinPrice(name: self.coin.officialName(), value: newValue)
                    let title = "Your " + self.coin.officialName() + " value: \(self.user.getCoinBalance(coinName: self.coin.officialName()))"
                    self.accountHolding.setTitle(title, for: .normal)
                }
                //: Confirmation
                let image = (newInput == 0) ? #imageLiteral(resourceName: "No Supply") : #imageLiteral(resourceName: "Supply")
                let title = "Success!"
                let keyword = (newInput == 0) ? "removed" : "added"
                let nextKeyword = (newInput == 0) ? "from" : "to"
                let description = "You have \(keyword) \(self.coin.officialName()) \(nextKeyword) your portfolio"
                self.showPopupMessage(attributes: self.defaultAttributes(), title: title, titleColor: .white, description: description, descriptionColor: .white, buttonTitleColor: UIColor(red: 0.380392, green: 0.380392, blue: 0.380392, alpha: 1), buttonBackgroundColor: .white, image: image)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        if #available(iOS 11, *) {
            priceContentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            priceContentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        }
        let customHeight = self.view.frame.height * 0.15
        priceContentView.anchor(top: nil, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: customHeight)
        
        let custom = (self.view.frame.height / 2) - customHeight
        chartView.anchor(top: priceContentView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: -3, paddingBottom: 0, paddingLeft: -9, paddingRight: -9, width: 0, height: custom)
        
        stackView.anchor(top: chartView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 22, paddingRight: 22, width: 0, height: 44)
        
        dividerView.anchor(top: stackView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        
        accountHolding.anchor(top: dividerView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 18, paddingRight: 18, width: 0, height: 35)
        
        containerView.anchor(top: accountHolding.bottomAnchor, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 18, paddingRight: 18, width: 0, height: 0)
        coinDescription.anchor(top:  containerView.topAnchor, bottom: containerView.bottomAnchor, left: self.containerView.leftAnchor, right: self.containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)

    }
    
    //: MARK - Attributes for popup message
    fileprivate func defaultAttributes() -> EKAttributes {
        var attributes = EKAttributes()
        attributes.name = nil
        //: Display
        attributes.windowLevel = .statusBar
        attributes.position = .bottom
        attributes.displayPriority = .normal
        attributes.displayDuration = .infinity
        attributes.positionConstraints.keyboardRelation = .unbind
        attributes.positionConstraints.size = .init(width: .offset(value: 0), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .intrinsic, height: .intrinsic)
        attributes.positionConstraints.verticalOffset = CGFloat(0)
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        
        //: User Interaction
        attributes.screenInteraction = .init(defaultAction: .dismissEntry, customTapActions: [])
        attributes.entryInteraction = .init(defaultAction: .absorbTouches, customTapActions: [])
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.hapticFeedbackType = .success
        attributes.lifecycleEvents = .init(willAppear: .none, didAppear: .none, willDisappear: .none, didDisappear: .none)
        
        //: Theme & Style - These colors are of the pop up view
        let firstColor = UIColor(red:0.99, green:0.78, blue:0.19, alpha:1.0)
        let secondColor = UIColor(red:0.95, green:0.45, blue:0.21, alpha:1.0)
        
        attributes.entryBackground = .gradient(gradient: .init(colors: [firstColor, secondColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
        
        let grayColor = UIColor(white: 0.392157, alpha: 0.3) /// hmm
        attributes.screenBackground = .color(color: grayColor)
        attributes.shadow = .active(with: .init(color: UIColor(white: 0, alpha: 1), opacity: 0.300000012, radius: 8, offset: CGSize(width: 0, height: 0)))
        attributes.roundCorners = .top(radius: 20)
        attributes.border = .none
        
        let spring = EKAttributes.Animation.Spring.init(damping: CGFloat(1), initialVelocity: CGFloat(0))
        let translation = EKAttributes.Animation.Translate.init(duration: 0.5, anchorPosition: .automatic, delay: 0, spring: spring)
        attributes.entranceAnimation = .init(translate: translation, scale: .none, fade: .none)
        let exitTranslation = EKAttributes.Animation.Translate.init(duration: 0.2, anchorPosition: .automatic, delay: 0, spring: .none)
        attributes.exitAnimation = .init(translate: exitTranslation, scale: .none, fade: .none)
        let popTranslate = EKAttributes.Animation.Translate.init(duration: 0.2, anchorPosition: .automatic, delay: 0, spring: .none)
        attributes.popBehavior = .animated(animation: EKAttributes.Animation.init(translate: popTranslate, scale: .none, fade: .none))
        return attributes
    }
    
    private func showPopupMessage(attributes: EKAttributes, title: String, titleColor: UIColor, description: String, descriptionColor: UIColor, buttonTitleColor: UIColor, buttonBackgroundColor: UIColor, image: UIImage? = nil) {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        if let image = image {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 60, height: 60), contentMode: .scaleAspectFit))
        }
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 24), color: titleColor, alignment: .center))
        let description = EKProperty.LabelContent(text: description, style: .init(font: MainFont.light.with(size: 16), color: descriptionColor, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: "Got it!", style: .init(font: MainFont.bold.with(size: 16), color: buttonTitleColor)), backgroundColor: buttonBackgroundColor, highlightedBackgroundColor: buttonTitleColor.withAlphaComponent(0.05))
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
            //: We can do a custom action here when user presses the button!
        }
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//: MARK - ChartViewDelegate
extension CoinController : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Chart description: \(entry.description)")
        //: Y-Value is the price
        priceContentView.coinPriceLabel.text = CurrencyFormatter.sharedInstance.formatAmount(entry.y, currency: "USD", options: nil)
        
        //: X-Value is time
        let date = Date(timeIntervalSince1970: entry.x)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "h:mm a EEEE, MMM dd, yyyy" // 4:00 PM Saturday, Aug 25, 2018
        let strDate = dateFormatter.string(from: date)
        priceContentView.dateLabel.text = strDate
        
        // Get the difference and percentage
        formatPrice(value: entry.y, isScrolling: true)
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //: If user deselects the chart, place the original price back
        priceContentView.coinPriceLabel.text =  "$" + coin.currentPrice
        priceContentView.dateLabel.text = ""
        formatPrice(value: 0.0, isScrolling: false)
    }
    
}

