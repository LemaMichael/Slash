//
//  CoinTableController.swift
//  Slash
//
//  Created by Michael Lema on 8/31/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

// https://bit.ly/2wCz2EO
protocol TableVCDelegate {
    func didFinishTableVC(controller: CoinTableViewController, coin: CryptoCoin)
}

class CoinTableViewController: UITableViewController {
    
    var coins = [CryptoCoin]() //: TODO: - Arrange the coins by marketCap
    var filteredCoins = [CryptoCoin]()
    var delegate: TableVCDelegate! = nil
    
    lazy var searchController: UISearchController = {
        let sC = UISearchController(searchResultsController: nil)
        sC.searchResultsUpdater = self
        sC.obscuresBackgroundDuringPresentation = false
        sC.searchBar.placeholder = "Search Coins..."        
        return sC
    }()
    
    private let headerId = "headerId"
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        //: Change this to false if i add my own custom back button
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupSearchController() {
        self.tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
        UISearchBar.appearance().tintColor = .white //: Changes the cancel button color
        
        //https://stackoverflow.com/questions/33751292/cannot-change-search-bar-background-color
        for subView in searchController.searchBar.subviews {
            for subViewOne in subView.subviews {
                    subViewOne.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            }
        }
        
        //: Changes the textColor of the UISearchBar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        
        //: Change search bar background color
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        searchController.searchBar.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        searchController.searchBar.barStyle = .black
    }
    
    /// https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCoins = coins.filter({( coin: CryptoCoin) -> Bool in
            return coin.data.fullName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func setupTableView() {
        tableView.separatorColor = UIColor.rgb(red: 31, green: 31, blue: 31)
        tableView.backgroundColor = UIColor.rgb(red: 39, green: 38, blue: 39)
        tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(CoinTableCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK: HEADER
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
        return header
    }
    
    // MARK: CELL
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredCoins.count : coins.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CoinTableCell
        cell.selectionStyle = .none //: Get rid of the default color when tapped
        
        //: Modify the full width of the divider to
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        let coin = isFiltering() ? filteredCoins[indexPath.row] : coins[indexPath.row]
        cell.symbolLabel.text = coin.data.symbol
        cell.nameSubLabel.text = coin.data.coinName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let coin = isFiltering() ? filteredCoins[indexPath.row] : coins[indexPath.row]
        print("!coin: \(coin.data.name) was selected")
        self.navigationController?.popViewController(animated: true)
        delegate.didFinishTableVC(controller: self, coin: coin)
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.rgb(red: 47, green: 47, blue: 47)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.rgb(red: 35, green: 35, blue: 35)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.searchBar.becomeFirstResponder()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension CoinTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: Header
class CustomTableViewHeader: UITableViewHeaderFooterView {
    let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent"
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Light", size: 14)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupFooter()
    }
    func setupFooter() {
        contentView.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0)
        addSubview(recentLabel)
        recentLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 150, height: 0)
    }
}

// MARK: Cell
class CoinTableCell: UITableViewCell {
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Heavy", size: 18)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    let nameSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Medium", size: 14)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    func setupCell() {
        contentView.backgroundColor = UIColor.rgb(red: 35, green: 35, blue: 35)

        addSubview(symbolLabel)
        addSubview(nameSubLabel)
        
        symbolLabel.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 11, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 320, height: 20)
        nameSubLabel.anchor(top: symbolLabel.bottomAnchor, bottom: self.bottomAnchor, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: -11, paddingLeft: 12, paddingRight: 0, width: 320, height: 20)
    }
}
