//
//  Block.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/11/03.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB

class Block: NSObject {
    
    var objectId : String
    var blocking : NCMBUser
    var user : NCMBUser
    
    init(objectId : String, blocking : NCMBUser, user : NCMBUser) {
        self.objectId = objectId
        self.blocking = blocking
        self.user = user
    }
    
    
}
