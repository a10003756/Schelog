//
//  SideMenuViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/28.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var sideMenuTableView : UITableView!
    var dateValue = String()
    let sectionTitle = ["スケジュールを追加する","日記を書く"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuTableView.dataSource = self
        sideMenuTableView.delegate = self
        
        sideMenuTableView.rowHeight = 75
        sideMenuTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTitle.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        cell.textLabel?.text = sectionTitle[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toScheduled", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "toDiary", sender: nil)
        
        default:
            print("nil")
        }
    }

    

}
