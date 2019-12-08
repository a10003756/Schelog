//
//  Dialy.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/29.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB

class Diary {
    var objectId : String
    var user : NCMBUser
    var date : String
    var title : String
    var content : String
    var image : String?
    var createDate : Date
    
    init(objectId : String,user : NCMBUser, date : String ,title : String, content : String, image : String,  createDate : Date ) {
        self.objectId = objectId
        self.user = user
        self.date = date
        self.title = title
        self.content = content
        self.image = image
        self.createDate = createDate
        
    }

}
