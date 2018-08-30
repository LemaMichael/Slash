//
//  CryptoCompKit.swift
//  Vault
//
//  Created by Steve on 5/9/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class CryptoCompKit {

    let request = Request()
    
    public init() { }
    
    public func coinList(complete:@escaping (_ coinList:CoinList,_ result:Result<Any>)->Void) {
        request.run(router: Router.coinList(), factory: Factory.coinList) { result in
            if let coinList = result.value() as? CoinList {
                complete(coinList, result)
            }  else {
                complete(CoinList(), result)
            }
        }
    }
    
    public func priceList(fSyms:[String], tSyms:[String], complete:@escaping (_ priceList:PriceList,_ result:Result<Any>)->Void) {
        let router = Router.priceList(fSyms: fSyms, tSyms: tSyms)
        request.run(router: router, factory: Factory.priceList) { result in
            if let priceList = result.value() as? PriceList {
                complete(priceList, result)
            } else {
                complete(PriceList(), result)
            }
        }
    }
    
    public func histoMinutes(fSym:String, tSym:String, complete:@escaping (_ histoList:HistoList,_ result:Result<Any>)->Void) {
        let router = Router.histoMinute(fSym:fSym, tSym:tSym)
        request.run(router: router, factory: Factory.histoMinute) { result in
            if let histoList = result.value() as? HistoList {
                complete(histoList, result)
            } else {
                complete(HistoList(), result)
            }
        }
    }
    
}
