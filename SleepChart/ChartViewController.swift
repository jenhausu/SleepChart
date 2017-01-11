//
//  ChartViewController.swift
//  SleepGraph
//
//  Created by 蘇健豪1 on 2017/1/9.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import UIKit
import HealthKit

class ChartViewController: UIViewController {
    let healthStore = HealthKitClass.sharedInstance.healthStore
    
    var sleepDatas : [HKCategorySample] = []
    var avgSleepTime : [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readData()
    }
    
    fileprivate func readData() {
        let q = HKSampleQuery.init(sampleType: HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!,
                                   predicate: nil,
                                   limit: HKObjectQueryNoLimit,
                                   sortDescriptors: nil,
                                   resultsHandler: {(query:HKSampleQuery, sample:[HKSample]?, error:Error?) -> Void in
                                    if let results = sample {
                                        for result in results {
                                            if let sleepData = result as? HKCategorySample {
                                                self.sleepDatas.append(sleepData)
                                            }
                                        }
                                        
                                        self.processData()
                                    }
                                    else {
                                        // No results were returned, check the error
                                    }
        })
        healthStore.execute(q)
    }
    
    fileprivate func processData() {
        for index in 0...self.sleepDatas.count - 1 {
            let goToBedTime = self.sleepDatas[index].startDate
            let wakeUpTime = self.sleepDatas[index].endDate
            let sleepTime = DateInterval.init(start: goToBedTime, end: wakeUpTime).duration
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "e"
            let e = Int(dateFormat.string(from: wakeUpTime))!
            
            if avgSleepTime[e] == 0 {
                avgSleepTime[e] = sleepTime
            }
            else {
                avgSleepTime[e] = (avgSleepTime[e] + sleepTime) / 2
            }
        }
    }
}
