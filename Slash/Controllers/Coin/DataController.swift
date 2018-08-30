//
//  ETHController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import GDAXKit
import Charts

class DataController: UIViewController {
    
    // Initialize a client
    let client = MarketClient()
    var chartDataEntry = [ChartDataEntry]()
    
    
    func getHistoricData(coinID: String, selectedRange: String) {
        
        //: Get historic data
        //let coinID = "BTC-USD"
        var range = DateRange.oneDay
        var granularity = Granularity.oneHour
        
        switch selectedRange {
        case "1D":
            print("! 1D called")
            //: We should return since it is the default chart
            //: NOTE: oneWeek (range) and granularity (oneHour) gives entire day with one hour interval
            range = DateRange.oneWeek
            granularity = Granularity.oneHour
        case "1H":
            print("! 1H Called")
            range = DateRange.oneDay
            //granularity = Granularity.oneMinute - can't do.
            granularity = Granularity.fiveMinutes
        case "1W":
            print("! 1W CALLED")
            //: Can't do ONEWEEK and 6hours, fifteenMinutes, fiveMinutes
            range = DateRange.oneWeek
            //granularity = Granularity.sixHours - can't do
            granularity = Granularity.sixHours //: Gives more than a week
        case "1M":
            print("! 1M CALLED")
            range = DateRange.oneDay
            granularity = Granularity.oneDay
        case "1Y":
            //: NOTE: range (DateRange.fiveDays) and granularity (Granularity.oneHour) aug 14 - aug 27
            //: NOTE: range (DateRange.fiveDays) and granularity (Granularity.sixhours) jun 12 - aug 26
            //: NOTE: range (DateRange.fiveDays) and granularity (Granularity.oneDay) oct 31 2017 - aug 26
            //: NOTE: range (DateRange.oneQuarter) and granularity (Granularity.oneDay) oct 31 2017 - aug 26
            //: NOTE: range (DateRange.threeDays) and granularity (Granularity.fifteenMinutes) aug 23 - aug 26
            //: NOTE: range (DateRange.threeDays) and granularity (Granularity.onehour) aug 14 2017 - aug 27
            //: NOTE: range (DateRange.oneMonth) and granularity (Granularity.sixhours) jun 12 - aug 27
            //: NOTE: range (DateRange.oneMonth) and granularity (Granularity.ondeDay) oct 31, 2017 - aug 26
            
            print("! 1Y CALLED")
            //            range = DateRange.oneYear
            //            granularity = Granularity.oneDay
            //            granularity = Granularity.sixHours
            //            granularity = Granularity.oneHour
            //            granularity = Granularity.fifteenMinutes
            //            granularity = Granularity.fiveMinutes
            //            granularity = Granularity.oneMinute
            
            //            range = DateRange.fiveDays
            //            granularity = Granularity.oneMinute
            //            granularity = Granularity.fiveMinutes
            //            granularity = Granularity.fifteenMinutes
            //            granularity = Granularity.oneHour
            //            granularity = Granularity.sixHours
            //            granularity = Granularity.oneDay
            
            //            range = DateRange.oneQuarter
            //            granularity = Granularity.oneMinute
            //            granularity = Granularity.fiveMinutes
            //             granularity = Granularity.fifteenMinutes
            //            granularity = Granularity.oneHour
            //           granularity = Granularity.sixHours
            //            granularity = Granularity.oneDay
            
            //            range = DateRange.threeDays
            //            granularity = Granularity.oneMinute
            //            granularity = Granularity.fiveMinutes
            //             granularity = Granularity.fifteenMinutes
            //             granularity = Granularity.oneHour
            //            granularity = Granularity.sixHours
            //             granularity = Granularity.oneDay
            
            range = DateRange.oneMonth
            //            granularity = Granularity.oneMinute
            //            granularity = Granularity.fiveMinutes
            //              granularity = Granularity.fifteenMinutes
            //              granularity = Granularity.oneHour
            //            granularity = Granularity.sixHours
            granularity = Granularity.oneDay
            
            
        case "All":
            print("! All CALLED")
            //: NOTE: range (DateRange.oneWeek) and granularity (Granularity.oneHour) aug 14 - aug 26
            //: NOTE: range (DateRange.oneWeek) and granularity (Granularity.sixhours) jun 12 - aug 26
            //: NOTE: range (DateRange.oneWeek) and granularity (Granularity.oneDay) nov 1 2017 - aug 26
            
            //            range = DateRange.fiveYears
            //            granularity = Granularity.oneDay
            //            granularity = Granularity.fifteenMinutes
            //            granularity = Granularity.oneHour
            //            granularity = Granularity.fiveMinutes
            //            granularity = Granularity.oneMinute
            //            granularity = Granularity.sixHours
            
            //            range = DateRange.oneYear
            //            granularity = Granularity.oneMinute
            //              granularity = Granularity.fiveMinutes
            //            granularity = Granularity.fifteenMinutes
            //            granularity = Granularity.oneHour
            //            granularity = Granularity.sixHours
            //            granularity = Granularity.oneDay
            
            //            range = DateRange.threeYears
            //            granularity = Granularity.oneMinute
            //              granularity = Granularity.fiveMinutes
            //            granularity = Granularity.fifteenMinutes
            //            granularity = Granularity.oneHour
            //            granularity = Granularity.sixHours
            //            granularity = Granularity.oneDay
            
            //            range = DateRange.oneWeek
            //             granularity = Granularity.oneMinute
            //            granularity = Granularity.fiveMinutes
            //            granularity = Granularity.fifteenMinutes
            //            granularity = Granularity.oneHour
            //            granularity = Granularity.sixHours
            //            granularity = Granularity.oneDay
            
            //            range = DateRange.fiveYears
            //            granularity = Granularity.oneMinute
            //            granularity = Granularity.fiveMinutes
            //            granularity = Granularity.fifteenMinutes
            //              granularity = Granularity.oneHour
            //            granularity = Granularity.sixHours
            //            granularity = Granularity.oneDay
            
            
        default:
            return
        }
        
        
        client.historic(pid:coinID, range:range, granularity:granularity) { candles, result in
            self.chartDataEntry.removeAll()
            switch result {
            case .success(_):
                //: Each candle has a time, low, high. open, close, volume
                for item in candles {
                    print(item.time, item.open, item.close, item.high, item.low)
                    let xVal = Double(item.time.timeIntervalSince1970)
                    print(xVal)
                    let yVal = item.close
                    print("!\(self.chartDataEntry.count)")
                    self.chartDataEntry.append(ChartDataEntry(x: xVal, y: yVal))
                    
                }
                print("! We are now appending: pid \(coinID)")
                
            case .failure(let error):
                print(error.localizedDescription)
                //: One of the reasons we are here is because we are making too much requests at a time
                print("!The current pid was not added \(coinID)")
                self.requestAgain(coinID, selectedRange: range, granularity: granularity)
                
            }
        }
        
    }
    
    func requestAgain(_ coinID: String, selectedRange: DateRange, granularity: Granularity ) {
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            print("! I am in request again")
            self.client.historic(pid: coinID, range: selectedRange, granularity:granularity) { candles, result in
                switch result {
                case .success(_):
                    //: Each candle has a time, low, high. open, close, volume
                    for item in candles {
                        print(item.time, item.open, item.close, item.high, item.low)
                        let xVal = Double(item.time.timeIntervalSince1970)
                        print(xVal)
                        let yVal = item.close
                        self.chartDataEntry.append(ChartDataEntry(x: xVal, y: yVal))
                        
                    }
                    print("! Was able to add: pid \(coinID)")
                    //: Hmmm
                // self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    //: One of the reasons we are here because we are making too much requests at a time
                    print("! The current pid was not added2 \(coinID)")
                    self.requestAgain(coinID, selectedRange: selectedRange, granularity: granularity)
                    
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
}
