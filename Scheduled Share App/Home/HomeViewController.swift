//
//  HomeViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/09.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarMinimumInteritemSpacing = 0
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "Scheduled", bundle: nil).instantiateViewController(withIdentifier: "Scheduled")
        let secondVC = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "Diary")
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }

}
