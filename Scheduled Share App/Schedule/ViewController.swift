//
//  ViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/26.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import SideMenu
import NCMB
import SVProgressHUD


class ViewController: UIViewController,FSCalendarDelegateAppearance,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource, ScheduledTableViewCellDelegate{
 
    var scheduledValue = ScheduledTableViewCell()
    
    var schedules = [Scheduled]()
    
    @IBOutlet var calender : FSCalendar!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var scheduledTableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        calender.dataSource = self
        calender.delegate = self
        
        scheduledTableView.dataSource = self
        scheduledTableView.delegate = self
        
        calender.scrollDirection = .vertical
        
        scheduledTableView.rowHeight = 100
        
        let nib = UINib(nibName: "ScheduledTableViewCell", bundle: Bundle.main)
        scheduledTableView.register(nib, forCellReuseIdentifier: "Cell")
    
}
    
    override func viewWillAppear(_ animated: Bool) {
        loadScheduled()
    }
    
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
  
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        return nil
    }
    
    
    

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        self.scheduledTableView.reloadData()
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        dateValue = "\(year)年\(month)月\(day)日"
        dateLabel.text = dateValue
        loadScheduled()
        
        
    }
    
    
    @IBAction func toSlideMenu(){
        self.performSegue(withIdentifier: "toSideMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowDiary"{
            let showDiaryViewController = segue.destination as! showDiaryViewController
            showDiaryViewController.dateValue = dateValue

        }
//
////        if segue.identifier == "toSideMenu"{
////            let sideMenuViewController = segue.destination as! SideMenuViewController
////            sideMenuViewController.dateValue = dateValue
////        }
//
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ScheduledTableViewCell
//

        cell.tag = indexPath.row
        cell.delegate = self
        
        
        cell.startTimeLabel.text = schedules[indexPath.row].startScheduledTime
        cell.endTimeLabel.text = schedules[indexPath.row].endScheduledTime
        cell.memoTextView.text = schedules[indexPath.row].memoScheduled
        cell.titleTextView.text = schedules[indexPath.row].scheduledContent
    
        return cell
    }
    
    
    
    func loadScheduled(){
        
        let query = NCMBQuery(className: "Scheduled")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("startDateScheduled", equalTo: dateValue)
        query?.order(byAscending: "startScheduledTime")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                if result!.count >= 1 {
                self.schedules = [Scheduled]()
                
                for scheduleObject in result as! [NCMBObject] {
                    
                    let user = scheduleObject.object(forKey: "user") as! NCMBUser
                    
                    if user.object(forKey: "active") as? Bool != false {
                        
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        
                        let scheduledContent = scheduleObject.object(forKey: "scheduledContent") as! String
                        let memoScheduled = scheduleObject.object(forKey: "memo") as! String
                        let endScheduledTime = scheduleObject.object(forKey: "endScheduledTime") as! String
                        let startScheduledTime = scheduleObject.object(forKey: "startScheduledTime") as! String
                    
                        let schedule = Scheduled(objectId: scheduleObject.objectId, user: userModel, scheduledContent: scheduledContent, memoScheduled: memoScheduled, endScheduledTime: endScheduledTime, startScheduledTime: startScheduledTime)
                        
                        
                        self.schedules.append(schedule)
                    }
                }
                } else {
                    self.schedules.removeAll()
                    
                }
                
                self.scheduledTableView.reloadData()
            }
            
        })
        
        
    }
    
    func didTapMenuButton(tableViewCell : UITableViewCell, button : UIButton){
        
        let alert = UIAlertController(title: "メニュー", message: "選んで下さい", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "削除する", style: .default) { (action) in
            let query = NCMBQuery(className: "Scheduled")
            query?.getObjectInBackground(withId: self.schedules[tableViewCell.tag].objectId, block: { (scheduled, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    scheduled?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadScheduled()
                            SVProgressHUD.dismiss()
                        }
                    })
                }
                
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            let screenSize = UIScreen.main.bounds
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

