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
                                                
                                                print(sleepData.startDate)
                                                print(sleepData.endDate)
                                            }
                                        }
                                    }
                                    else {
                                        // No results were returned, check the error
                                    }
        })
        healthStore.execute(q)
    }
}
