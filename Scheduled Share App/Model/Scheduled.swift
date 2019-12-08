//
//  Scheduled.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/29.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit

class Scheduled: NSObject {
    
    var objectId : String
    var user : User
    var endScheduledTime : String
    var startScheduledTime : String
    var scheduledContent : String
    var memoScheduled : String
    
    init(objectId : String, user : User, scheduledContent  : String, memoScheduled : String, endScheduledTime : String, startScheduledTime : String) {
       
        self.objectId = objectId
        self.user = user
        self.endScheduledTime = endScheduledTime
        self.scheduledContent = scheduledContent
        self.startScheduledTime = startScheduledTime
        self.memoScheduled = memoScheduled
    }
   
}
