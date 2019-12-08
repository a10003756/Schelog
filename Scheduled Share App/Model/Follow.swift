//
//  Follow.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/19.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB

class Follow: NSObject {
    
    var user : String
    var following : String
    
    init(user : String, following : String) {
        self.user = user
        self.following = following
    }
    
}
