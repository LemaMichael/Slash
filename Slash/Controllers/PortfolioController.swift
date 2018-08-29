//
//  LTCController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import Charts

class PortfolioController: UIViewController {
    
    fileprivate let cellID = "coinID"
    lazy var pieView = PieView()
    
    var totalPortfolioValue: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font =  UIFont(name: "AvenirNext-DemiBold", size: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 52, green: 53, blue: 69)
        return view
    }()
    var changeLabel: UILabel = {
       let label = UILabel()
        label.text = "+ $30.50 today"
        label.textColor = UIColor(red:0.27, green:0.75, blue:0.14, alpha:1.0)
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var coinCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.rgb(red: 35, green: 36, blue: 53)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PortfolioCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Portfolio"
        pieView.delegate = self
        pieView.setData()
        pieView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        view.backgroundColor = UIColor.rgb(red: 43, green: 44, blue: 62)
        self.view.addSubview(pieView)
        self.view.addSubview(totalPortfolioValue)
        self.view.addSubview(dividerView)
        self.view.addSubview(changeLabel)
        self.view.addSubview(coinCollectionView)
        setupViews()
    }
    
    func setupViews(){
        pieView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 300)
        //: Fix portfolio width
        totalPortfolioValue.anchor(top: pieView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 54.6)
        
        let width = (view.bounds.width / 2) - 50
        dividerView.anchor(top: totalPortfolioValue.bottomAnchor, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: width, height: 1)
        dividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeLabel.anchor(top: dividerView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 45)
        
        coinCollectionView.anchor(top: changeLabel.bottomAnchor, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//: MARK - ChartViewDelegate
extension PortfolioController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataEntry = entry as? PieChartDataEntry else { return }
        guard let validText = dataEntry.label else { return }
        let formatPrice = CurrencyFormatter.sharedInstance.formatAmount(entry.y, currency: "USD", options:nil)
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "\(formatPrice)\n\(validText)")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.foregroundColor : UIColor.white], range: NSRange(location: 0, length: centerText.length))
        pieView.centerAttributedText = centerText;
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        pieView.centerAttributedText = nil
    }
}

//: MARK - UICollectionViewDelegate, UICollectionViewDataSource
extension PortfolioController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! PortfolioCell
        return cell
    }
}

//: MARK - UICollectionViewDelegateFlowLayout
extension PortfolioController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: (collectionView.frame.height / 4)) 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


