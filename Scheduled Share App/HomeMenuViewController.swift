//
//  HomeMenuViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/10.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeMenuViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = UIColor.lightGray
        // タブの色
        settings.style.buttonBarItemBackgroundColor = UIColor.lightGray
        // タブの文字サイズ
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15)
        // カーソルの色
        buttonBarView.selectedBar.backgroundColor = UIColor.darkGray
//        super.viewDidLoad()
        
        super.viewDidLoad()
    }
    
//    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
//        let homeScheduledViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Scheduled")
//        let homeDailyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Daily")
//        let homeViewControllers:[UIViewController] = [homeScheduledViewController,homeDailyViewController]
//        return homeViewControllers
//    }

    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs: [UIViewController] = []
        let table1 =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notebook_table") as! HomeScheduledViewController
        table1.noteBookName = "Notebook1"
        vcs.append(table1)
        let table2 =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notebook_table") as! HomeDialyViewController
        table2.noteBookName = "Notebook2"
        vcs.append(table2)
        return vcs
    }
}
