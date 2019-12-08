//
//  SearchViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/09.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD

class SearchViewController: UIViewController,UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource , SearchUserTableViewCellDelegate{
   
    
    var searchBar : UISearchBar!
    var users = [NCMBUser]()
    @IBOutlet var searchTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers(searchText: nil)

        searchTableView.rowHeight = 60
        searchTableView.delegate = self
        searchTableView.dataSource = self
//        searchBar.delegate = self
        
        setSearchBar()
        
        let nib = UINib(nibName: "SearchUserTableViewCell", bundle: Bundle.main)
        searchTableView.register(nib, forCellReuseIdentifier: "SearchCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUsers(searchText: nil)
    }

    func setSearchBar(){
        
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            
            searchBar.placeholder = "ユーザーを検索"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        loadUsers(searchText: nil)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadUsers(searchText: searchBar.text)
    }
    
  
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        loadUsers(searchText: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchUserTableViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/VAirdJMPKVZ26nJL/publicFiles/" + users[indexPath.row].objectId
        cell.userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "placeholder.jpg"))
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2.0
        cell.userImageView.layer.masksToBounds = true
        cell.userNameLabel.text = users[indexPath.row].object(forKey: "displayName") as? String
        
        let query = NCMBQuery(className: "Follow")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("following", equalTo: users[indexPath.row].object(forKey: "user") )
        query?.getFirstObjectInBackground({ (follow, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                if follow != nil{
                    print("1")
                }
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadUsers(searchText : String?){
        
        if searchText != nil {
    
        let query = NCMBUser.query()
        
        query?.whereKey("objectId", notEqualTo: NCMBUser.current()?.objectId)
        query?.whereKey("active", notEqualTo: false)
        query?.whereKey("userName", equalTo: searchBar.text)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.users = result as! [NCMBUser]
                self.searchTableView.reloadData()
                    }
                })
            }
    }
    

    
   
    func didTapFollowButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        let displayName = users[tableViewCell.tag].object(forKey: "displayName") as? String
        if displayName != nil {
            let message = displayName! + "をフォローしますか？"
            let alert = UIAlertController(title: "フォロー", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.follow(selectedUser: self.users[tableViewCell.tag])
            
            }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
            }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                if ( UI_USER_INTERFACE_IDIOM() == .pad ){
                    let screenSize = UIScreen.main.bounds
                    alert.popoverPresentationController?.sourceView = view
                    alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
        } else if displayName == nil {
            let message =  " をフォローしますか？"
                       let alert = UIAlertController(title: "フォロー", message: message, preferredStyle: .alert)
                       let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                       self.follow(selectedUser: self.users[tableViewCell.tag])
                       
                       }
                           let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                               alert.dismiss(animated: true, completion: nil)
                       }
                           alert.addAction(okAction)
                           alert.addAction(cancelAction)
                           if ( UI_USER_INTERFACE_IDIOM() == .pad ){
                               let screenSize = UIScreen.main.bounds
                               alert.popoverPresentationController?.sourceView = view
                               alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
                               self.present(alert, animated: true, completion: nil)
                           } else {
                               self.present(alert, animated: true, completion: nil)
                           }
        }
    }
    
    func follow(selectedUser : NCMBUser){
        let object = NCMBObject(className: "Follow")
        if let currentUser = NCMBUser.current(){
            object?.setObject(currentUser, forKey: "user" )
            object?.setObject(selectedUser, forKey: "following")
            object?.saveInBackground({ (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    self.loadUsers(searchText: nil)
                }
            })
        } else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            let ud = UserDefaults.standard
            ud.set(true, forKey: "isLogin")
            ud.synchronize()
    }
    
    }
   
}
