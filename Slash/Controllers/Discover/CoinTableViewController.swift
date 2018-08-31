//
//  CoinTableController.swift
//  Slash
//
//  Created by Michael Lema on 8/31/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class CoinTableViewController: UITableViewController {
    
    var coins = [CryptoCoin]() //: TODO: - Arrange the coins by marketCap
    var filteredCoins = [CryptoCoin]()
    let searchController = UISearchController(searchResultsController: nil)

    private let headerId = "headerId"
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    func setupSearchController() {
        UISearchBar.appearance().tintColor = .white //: Changes the cancel button color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white] //: Changes the textColor of the UISearchBar
        searchController.searchBar.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coins..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredCoins = coins.filter({( coin : CryptoCoin) -> Bool in
            return coin.data.fullName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor.rgb(red: 39, green: 38, blue: 39)
        tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(CoinTableCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK:- HEADER
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
        return header
    }
    
    // MARK:- CELL
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCoins.count
        }
        return coins.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CoinTableCell
        let coin: CryptoCoin
        if isFiltering() {
            coin = filteredCoins[indexPath.row]
        } else {
            coin = coins[indexPath.row]
        }
        cell.symbolLabel.text = coin.data.symbol
        cell.nameSubLabel.text = coin.data.coinName
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin: CryptoCoin
        if isFiltering() {
            coin = filteredCoins[indexPath.row]
        } else {
            coin = coins[indexPath.row]
        }
        print("!coin: \(coin.data.name) was selected")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension CoinTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


// MARK:- Header
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
        contentView.backgroundColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        addSubview(recentLabel)
        recentLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 150, height: 0)
    }
}

// MARK:- Cell
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

