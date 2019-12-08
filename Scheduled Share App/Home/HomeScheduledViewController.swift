//
//  HomeScheduledViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/10.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeScheduledViewController: UIViewController , IndicatorInfoProvider{

    var itemInfo: IndicatorInfo = "スケジュール"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
