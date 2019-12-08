//
//  User.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/29.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var objectId : String
    var userName : String
    var displayname : String?
    var introduction : String?

    
    init(objectId : String, userName : String) {
        self.objectId = objectId
        self.userName = userName
    }

}
