//
//  HealthKitClass.swift
//  SleepGraph
//
//  Created by 蘇健豪1 on 2017/1/9.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitClass: NSObject {
    class var sharedInstance: HealthKitClass {
        struct Singleton {
            static let instance = HealthKitClass()
        }
        
        return Singleton.instance
    }
    
    let healthStore = HKHealthStore()

}
