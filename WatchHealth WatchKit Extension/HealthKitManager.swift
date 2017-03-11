//
//  HealthKitManager.swift
//  WatchHealth
//
//  Created by TRIVIT on 1/5/17.
//  Copyright © 2017 TRIVIT. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    //create healthstore object if available
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable(){
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    //when creating a HealthKitManager, check authorization. In case user changes permission
    init(){
        if(checkAuthorization()){
            print("auth success")
        }
        else{
            print("auth failed")
        }
    }
    
    func checkAuthorization() -> Bool {
        //default its authorized
        var isEnabled = true
        //check if Healthkit is enabled again
        if HKHealthStore.isHealthDataAvailable(){
            let readData = Set(arrayLiteral: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
            let writeData = Set<HKQuantityType>()
            //request authorization for data to be written and read
            healthStore?.requestAuthorization(toShare: writeData, read: readData) { (success, error) -> Void in
                    isEnabled = success
                }
            
        }
        else{
            isEnabled = false
        }
        return isEnabled
    }
}
