//
//  UserPageViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/27.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD

class UserPageViewController: UIViewController,UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var userImage : UIImage?
    
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var userNameTextField : UITextField!
    @IBOutlet var userIdTextField : UITextField!
    @IBOutlet var introductionTextView : UITextView!
    @IBOutlet var followCountLabel : UILabel!
    @IBOutlet var followerCountLabel : UILabel!
    @IBOutlet var diaryCountLabel : UILabel!
    
    var follow = [Follow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        introductionTextView.layer.borderColor = UIColor.gray.cgColor
        introductionTextView.layer.borderWidth = 1.0
        
        self.diaryCountLabel.isUserInteractionEnabled = true
        self.followCountLabel.isUserInteractionEnabled = true
        self.followerCountLabel.isUserInteractionEnabled = true
        
        
        loadFollowDiary()
        
    
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil{
            } else {
                if data != nil{
                    let image = UIImage(data: data!)
                    self.userImageView.image = image
                    self.userImage = image
                }

            }
        }
        
        if let user = NCMBUser.current(){
            userIdTextField.text = user.object(forKey: "userName") as? String
            introductionTextView.text = user.object(forKey: "introduction") as? String
            if userNameTextField.text == nil {
                userNameTextField.text == user.object(forKey: "userNmae") as! String
            } else {
                userNameTextField.text = user.object(forKey: "displayName") as? String
            }
        }
    }
    
    @IBAction func menu(){
                let alert = UIAlertController(title: "メニュー", message: "", preferredStyle: .actionSheet)
                let logOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInStoryBoard")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
        }
            let deleteAlert = UIAlertAction(title: "アカウント消去", style: .default) { (action) in
                let user = NCMBUser.current()
                user?.deleteInBackground({ (error) in
                    if error == nil{
                    } else {
                        let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInStoryBoard")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                        let ud = UserDefaults.standard
                        ud.set(true, forKey: "isLogin")
                        ud.synchronize()
                        }
                    })
                }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
                
                alert.addAction(logOutAction)
                alert.addAction(deleteAlert)
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
    
    func loadFollowDiary(){
        
        let followQuery = NCMBQuery(className: "Follow")
        followQuery?.whereKey("user", equalTo: NCMBUser.current())
        followQuery?.countObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.followCountLabel.text = String(result)
                }
            }
        })
        
        let followerQuery = NCMBQuery(className: "Follow")
        followerQuery?.whereKey("following", equalTo: NCMBUser.current())
        followerQuery?.countObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.followerCountLabel.text = String(result)

                }
            }
        })
        
        let diaryQuery = NCMBQuery(className: "Diary")
        diaryQuery?.whereKey("user", equalTo: NCMBUser.current())
        diaryQuery?.countObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.diaryCountLabel.text = String(result)
                }
            }
        })
    }
    

    
}
