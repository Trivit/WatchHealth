//
//  CoreMotionManager.swift
//  WatchHealth
//
//  Created by TRIVIT on 1/10/17.
//  Copyright © 2017 TRIVIT. All rights reserved.
//

import Foundation
import CoreMotion

class CoreMotionManager {
    
    //Properties
    let activityManger = CMMotionActivityManager()
    let pedometer = CMPedometer()
    var startDay: Date
    let queue = OperationQueue()
    var totalSteps: Int
    var standTime: Double
    var timeWalking: Double
    var stepsWalking: Int
    
    
    init(){
        let date: Date = Date()
        let calendar: Calendar? = Calendar(identifier: Calendar.Identifier.gregorian)
        queue.maxConcurrentOperationCount = 1
        queue.name = "ActivityManagerQueue"
        startDay = calendar!.startOfDay(for: date)
        totalSteps = 0
        standTime = 0
        timeWalking = 0
        stepsWalking = 0
    }
    
    //gets steps from midnight to current time
    func getPreviousSteps() -> Int{
        //if stepcounting not available print error
        var previousSteps: Int = -1
        if (!CMPedometer.isStepCountingAvailable()){
            print("Pedometer not available")
            return previousSteps
        }
        //if its available query data from the start of the day
        else{
            pedometer.queryPedometerData(from: startDay, to: Date()) { (data: CMPedometerData? , error) -> Void in
                if(error != nil){
                    print("Error in query: \(error!)")
                }
                else{
                    print(data?.numberOfSteps ?? "Data not available")
                    previousSteps = (data!.numberOfSteps.intValue)
                }
            }//end handler
            return previousSteps
        }
    }
    
    //starts listening for updates of steps
    func startUpdatingSteps() -> Int{
        var updatedSteps: Int = -1
        if (!CMPedometer.isStepCountingAvailable()){
            print("Pedometer not available")
            return updatedSteps
        }
        else{
            pedometer.startUpdates(from: Date()) { (data : CMPedometerData?, error) -> Void in
                if(error != nil){
                    print(data?.numberOfSteps ?? "Data not available")
                    updatedSteps = (data!.numberOfSteps.intValue)
                }
                else{
                    print("Error in query: \(error!)")
                }
            }
        }//end handler
        return updatedSteps
    }
    
    //This will return the amount of active time in seconds
    func getPreviousActivity() -> Void {
        //use these variable to keep track of the previous activity info
        var previousActivity: String = "stationary"
        var previousDate: Date = startDay
        //if the device doesn't support motion (ie ipad)
        if(!CMMotionActivityManager.isActivityAvailable()){
            print("Activity not available on device")
        }
        else{
            //query data from start of day to current time
            activityManger.queryActivityStarting(from: startDay, to: Date(), to: queue) { (data: [CMMotionActivity]?, error: Error? ) -> Void in
                //if error print it
                if (error != nil){
                    print("error occured: \(error)")
                }
                //if data exists iterate over the array of data
                if(data != nil){
                    for motion in data!{
                        //here we have cases of what the current and previous activity are
                        if(previousActivity == "stationary"){
                            self.standTime += motion.startDate.timeIntervalSince(previousDate)
                        }
                        else if(previousActivity == "walking"){
                            self.timeWalking += motion.startDate.timeIntervalSince(previousDate)
                            self.pedometer.queryPedometerData(from: previousDate, to: motion.startDate) { (data: CMPedometerData? , error) -> Void in
                                if(error != nil){
                                    print("Error in query: \(error!)")
                                }
                                else{
                                    self.stepsWalking += (data!.numberOfSteps.intValue)
                                }
                            }//end pedometer query
                        }//end walking if
                        previousDate = motion.startDate
                        if(motion.stationary){
                            previousActivity = "stationary"
                        }
                        else if(motion.walking){
                            previousActivity = "walking"
                        }
                        else{
                            previousActivity = "other"
                        }
                    }//end loop over motion
                }//end if data loop
            }//end query if
        }//end else
    }//end function
    
    func startUpdatingActivity() -> Void {
        var previousActivity: String = "stationary"
        var previousDate: Date = Date()
        if(!CMMotionActivityManager.isActivityAvailable()){
            print("Activity not available on device")
        }
        else{
            //query for new data
            activityManger.startActivityUpdates(to: queue) { (data: CMMotionActivity?) -> Void in
                if(data == nil){
                    print("no new motion, data nil")
                }
                else{
                    if(previousActivity == "stationary"){
                        self.standTime += data!.startDate.timeIntervalSince(previousDate)
                    }
                    else if(previousActivity == "walking"){
                        self.timeWalking += data!.startDate.timeIntervalSince(previousDate)
                        self.pedometer.queryPedometerData(from: previousDate, to: data!.startDate) { (data: CMPedometerData? , error) -> Void in
                            if(error != nil){
                                print("Error in query: \(error!)")
                            }
                            else{
                                self.stepsWalking += (data!.numberOfSteps.intValue)
                            }
                        }//end pedometer query
                    }//end walking if
                    previousDate = data!.startDate
                    if(data!.stationary){
                        previousActivity = "stationary"
                    }
                    else if(data!.walking){
                        previousActivity = "walking"
                    }
                    else{
                        previousActivity = "other"
                    }

                }
            }
        }
    }
    
    
    func secondsDate(date1: Date, date2: Date) -> Double {
        return date1.timeIntervalSince(date2)
    }
    
}




