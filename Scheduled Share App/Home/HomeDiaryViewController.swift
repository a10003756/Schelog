//
//  HomeDialyViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/10.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NCMB
import SVProgressHUD


class HomeDiaryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , DiaryTableViewCellDelegate{

    var selectedDiary : Diary?
    var blockings = [NCMBUser]()
    var followings = [NCMBUser]()
    var users = [NCMBUser]()
    var diaries = [Diary]()
    var block = [Block]()
    var blockingUserId = [String]()
    var blockedUSerId = [String]()
    var postUserId = [String]()

    @IBOutlet var diaryTableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //引っ張って更新
        setRefresh()
        //フォローしている人を読み込む
        loadFollow()
        //ブロックしている人を読み込む
        loadBlocking()
        //ブロックされている人を読み込む
        loadBlocked()
        //currentUserがnilかどうか確かめる
        loadUserInfo()
        
        let nib = UINib(nibName: "DiaryTableViewCell", bundle: nil)
        diaryTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        diaryTableView.dataSource = self
        diaryTableView.delegate = self
        
        diaryTableView.register(nib, forCellReuseIdentifier: "Cell")
        diaryTableView.rowHeight = 133
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSentence" {
            let sentenceViewController = segue.destination as! SentenceViewController
            sentenceViewController.selectedDiary = selectedDiary
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diaryTableView.dequeueReusableCell(withIdentifier: "Cell") as! DiaryTableViewCell
        cell.tag = indexPath.row
        let user = diaries[indexPath.row].user
        
        cell.userImage.layer.cornerRadius = cell.userImage.bounds.width / 2.0
        cell.userImage.layer.masksToBounds = true
        cell.titleLabel.layer.borderColor = UIColor.gray.cgColor
        cell.titleLabel.layer.borderWidth = 1.0
        cell.dateLabel.layer.borderColor = UIColor.gray.cgColor
        cell.dateLabel.layer.borderWidth = 1.0
        cell.nameLabel.layer.borderColor = UIColor.gray.cgColor
        cell.nameLabel.layer.borderWidth = 1.0
        
        cell.delegate = self
        let displayName = user.object(forKey: "displayName") as? String
        cell.nameLabel.text = displayName
        cell.dateLabel.text = diaries[indexPath.row].date
        cell.titleLabel.text = diaries[indexPath.row].title
        
        let image = "https://mbaas.api.nifcloud.com/2013-09-01/applications/VAirdJMPKVZ26nJL/publicFiles/" + user.objectId
        cell.userImage?.kf.setImage(with: URL(string: image))
        
        cell.contentTextView.text = diaries[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableViewCell をタップした時の処理
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadFollow(){
        //フォロー情報の読み込み
        let query = NCMBQuery(className: "Follow")
        if let currentUser = NCMBUser.current(){
            query?.whereKey("user", equalTo: currentUser)
            query?.findObjectsInBackground({ (result, error) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    self.followings = [NCMBUser]()
                    for follows in result as! [NCMBObject] {
                    self.followings.append(follows.object(forKey: "following") as! NCMBUser)
                    }
                    self.followings.append(NCMBUser.current())
                }
                self.loadDiary()
            })
        }
    }
    
    func loadBlocked(){
        //ブロック情報の読み込み
        let query = NCMBQuery(className: "Block")
        if let currentUser = NCMBUser.current(){
            query?.whereKey("blocking", equalTo: currentUser)
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    self.blockings = [NCMBUser]()
                    for blocks in result as! [NCMBObject]{
                        self.blockings.append(blocks.object(forKey: "blocking") as! NCMBUser)

                        let blocking = blocks.object(forKey: "blocking") as! NCMBUser
                        let user = blocks.object(forKey: "user") as! NCMBUser

                        let blockings = Block(objectId: blocks.objectId, blocking: blocking, user: user)
                        self.block.append(blockings)
                        self.blockings.append(blocking)
                        let Id = user.object(forKey: "objectId") as! String
                        let id = blocking.object(forKey: "objectId") as! String
                        self.blockingUserId = [Id]
                        self.blockedUSerId = [id]
                    }
                }
                self.loadDiary()
            })
        }
    }
    
    func loadBlocking(){
        //ブロック情報の読み込み
        let query = NCMBQuery(className: "Block")
        if let currentUser = NCMBUser.current(){
            query?.whereKey("user", equalTo: currentUser)
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    self.blockings = [NCMBUser]()
                    for blocks in result as! [NCMBObject]{
                        self.blockings.append(blocks.object(forKey: "blocking") as! NCMBUser)

                        let blocking = blocks.object(forKey: "blocking") as! NCMBUser
                        let user = blocks.object(forKey: "user") as! NCMBUser

                        let blockings = Block(objectId: blocks.objectId, blocking: blocking, user: user)
                        let id = blocking.object(forKey: "objectId") as! String
                        self.blockedUSerId = [id]
                    }
                }
                self.loadDiary()
            })
        }
    }
    
    func loadDiary() {
        //日記の読み込み
        let query = NCMBQuery(className: "Diary")
        query?.order(byDescending: "createDate")
        query?.includeKey("user")
//        query?.whereKey("user", notContainedIn: blockings)
        query?.whereKey("user", containedIn: followings)
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.diaries = [Diary]()
                for diaryObject in result as! [NCMBObject] {
                        let user = diaryObject.object(forKey: "user") as! NCMBUser
                    var trueUser = self.blockingUserId.filter {$0 == user.objectId}
                    var truetrueUser = self.blockedUSerId.filter {$0 == user.objectId}
                    if trueUser.count > 0 || truetrueUser.count > 0{
                        return
                    }else {
                        
                        if user.object(forKey: "active") as? Bool != false {
                            let userModel = User(objectId: user.objectId, userName: user.userName)
                            userModel.displayname = user.object(forKey: "displayName") as? String
                            let date = diaryObject.object(forKey: "date") as! String
                            let title = diaryObject.object(forKey: "title") as! String
                            let content = diaryObject.object(forKey: "content") as! String
                            let image = "https://mbaas.api.nifcloud.com/2013-09-01/applications/VAirdJMPKVZ26nJL/publicFiles/" + user.objectId
                            
                            let Id = user.object(forKey: "objectId") as! String
                            self.postUserId.append(Id)
                            
                            
                            let trueId = [String]()
                            
                            if image != nil {
                                let diary = Diary(objectId: diaryObject.objectId, user: user, date: date, title: title, content: content,image: image, createDate: user.createDate)
                                self.diaries.append(diary)
                            } else {
                                let placeholder = "placeholder.jpg"
                                let diary = Diary(objectId: diaryObject.objectId, user: user, date: date, title: title, content: content, image: placeholder, createDate: user.createDate)
                                
                                self.diaries.append(diary)
                            }
                        }
                    }
                    self.diaryTableView.reloadData()

                    }
                    
                      
                }
        })
    }
        
    func didTapSentenceButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedDiary = diaries[tableViewCell.tag]
   
        self.performSegue(withIdentifier: "toSentence", sender: nil)
    }
    

    func didTapMenuButton(tableViewCell : UITableViewCell, button : UIButton){
        
        selectedDiary = diaries[tableViewCell.tag]
        let alert = UIAlertController(title: "メニュー", message: "選んでください", preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "報告する", style: .default) { (action) in
            SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
        }
        let blockAction = UIAlertAction(title: "このユーザーをブロックする", style: .default) { (action) in
            let object = NCMBObject(className: "Block")
            if let currentUser = NCMBUser.current(){
                object?.setObject(currentUser, forKey: "user")
                object?.setObject(self.diaries[tableViewCell.tag].user, forKey: "blocking")
                
                object?.saveInBackground({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        return
                    }
                })
            }
          
        }
        
        let deleteAction = UIAlertAction(title: "削除する", style: .default) { (action) in
            SVProgressHUD.show()
            let query = NCMBQuery(className: "Diary")
            query?.getObjectInBackground(withId: self.diaries[tableViewCell.tag].objectId, block: { (diary, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    diary?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadDiary()
                            SVProgressHUD.dismiss()
                        }
                    })
                }
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let selectedUser = self.diaries[tableViewCell.tag].user.objectId
        if selectedUser != NCMBUser.current()?.objectId{
        alert.addAction(reportAction)
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
                         let screenSize = UIScreen.main.bounds
                         alert.popoverPresentationController?.sourceView = view
                         alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil )
        } else {
            self.present(alert, animated: true, completion: nil)
            }
        } else {
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            if ( UI_USER_INTERFACE_IDIOM() == .pad ){
                             let screenSize = UIScreen.main.bounds
                             alert.popoverPresentationController?.sourceView = view
                             alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
            self.present(alert, animated: true, completion: nil )
            } else {
                self.present(alert, animated: true, completion: nil)
                }
        }
    }
 
    func setRefresh(){
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        diaryTableView.addSubview(refreshController)
    }
    
    @objc func reloadTimeline(refreshControl : UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.loadDiary()
        refreshControl.endRefreshing()
        
    }
    
    func loadUserInfo(){
        if let currentUser = NCMBUser.current() {
            return
        } else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                       let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInStoryBoard")
                       UIApplication.shared.keyWindow?.rootViewController = rootViewController
                       
                       let ud = UserDefaults.standard
                       ud.set(true, forKey: "isLogin")
                       ud.synchronize()
        }
    }
}



