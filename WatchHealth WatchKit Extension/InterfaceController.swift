//
//  InterfaceController.swift
//  WatchHealth WatchKit Extension
//
//  Created by TRIVIT on 12/30/16.
//  Copyright © 2016 TRIVIT. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController {
    @IBOutlet var stepsLabel: WKInterfaceLabel!
    @IBOutlet var activityTimeLabel: WKInterfaceLabel!
    @IBOutlet var cadenceLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


}
