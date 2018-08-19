//
//  Unwrap.swift
//  GDAXKit
//
//  Created by Steve on 1/25/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

class Unwrap {

    public class func products(_ result:Result<Any>)->[Product] {
        let value = result.value()
        if let products = value as? [Product] {
            return products
        }
        return []
    }
    
    public class func currencies(_ result:Result<Any>)->[Currency] {
        let value = result.value()
        if let currencies = value as? [Currency] {
            return currencies
        }
        return []
    }
    
    public class func book(_ result:Result<Any>)->[Book] {
        let value = result.value()
        if let books = value as? [Book] {
            return books
        }
        return []
    }
    
    public class func ticker(_ result:Result<Any>)->[Ticker] {
        let value = result.value()
        if let tickers = value as? [Ticker] {
            return tickers
        }
        return []
    }
    
    public class func trades(_ result:Result<Any>)->[Trade] {
        let value = result.value()
        if let trades = value as? [Trade] {
            return trades
        }
        return []
    }
    
    public class func candles(_ result:Result<Any>)->[Candle] {
        let value = result.value()
        if let candles = value as? [Candle] {
            return candles
        }
        return []
    }
    
    public class func stats(_ result:Result<Any>)->[Stat] {
        let value = result.value()
        if let stats = value as? [Stat] {
            return stats
        }
        return []
    }
    
    public class func time(_ result:Result<Any>)->[ServerTime] {
        let value = result.value()
        if let times = value as? [ServerTime] {
            return times
        }
        return []
    }
    
}
