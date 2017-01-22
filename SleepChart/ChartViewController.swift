//
//  ChartViewController.swift
//  SleepGraph
//
//  Created by 蘇健豪1 on 2017/1/9.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import UIKit
import HealthKit
import PNChart

class ChartViewController: UIViewController {
    let healthStore = HealthKitClass.sharedInstance.healthStore
    let notificationCenter = NotificationCenter.default
    
    var sleepDatas : [HKCategorySample] = []
    var avgSleepTime : [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(forName:Notification.Name(rawValue:"DataProcessDone"), object:nil, queue:nil) {notification in
            DispatchQueue.main.async {
                self.pnchart()
            }
        }
        
        readData()
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        
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
                                        
                                        
                                        let notification = Notification.Name("DataProcessDone")
                                        self.notificationCenter.post(name: notification, object: nil)
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
        
        for i in 1...7 {
            avgSleepTime[i] = avgSleepTime[i] / 3600
        }
    }
    
    @objc fileprivate func pnchart() {
        let rect  = CGRect(x: 10, y: 40, width: self.view.frame.width - 50, height: self.view.frame.height - 100)
        let barChart = PNBarChart.init(frame: rect)
        
        barChart.xLabels = ["週日", "週一", "週二", "週三", "週四", "週五", "週六"]
        barChart.yLabels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        barChart.yValues = [avgSleepTime[1], avgSleepTime[2], avgSleepTime[3], avgSleepTime[4], avgSleepTime[5], avgSleepTime[6], avgSleepTime[7]]
        
        barChart.stroke()
        self.view.addSubview(barChart)
        
    }
}
