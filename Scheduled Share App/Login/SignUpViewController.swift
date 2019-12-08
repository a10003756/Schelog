//
//  SignUpViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/26.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var userIdTextField : UITextField!
    @IBOutlet var mailAdressTextField : UITextField!
    @IBOutlet var passwardTextField : UITextField!
    @IBOutlet var confirmTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        mailAdressTextField.delegate = self
        passwardTextField.delegate = self
        confirmTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUp(){
        
        let user = NCMBUser()
        user.userName = userIdTextField.text
        user.mailAddress = mailAdressTextField.text
        
        if passwardTextField.text == confirmTextField.text{
            user.password = passwardTextField.text
        } else {
        }
           user.signUpInBackground { (error) in
                 if error != nil {
                     // エラーがあった場合
                     SVProgressHUD.showError(withStatus: error!.localizedDescription)
                 } else {
                     let acl = NCMBACL()
                     acl.setPublicReadAccess(true)
                     acl.setWriteAccess(true, for: user)
                     user.acl = acl
                     user.saveEventually({ (error) in
                         if error != nil {
                             SVProgressHUD.showError(withStatus: error!.localizedDescription)
                             self.navigationController?.popViewController(animated: true)
                         } else {
                             // 登録成功
                             let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                             let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
                             UIApplication.shared.keyWindow?.rootViewController = rootViewController
                             
                             // ログイン状態の保持
                             let ud = UserDefaults.standard
                             ud.set(true, forKey: "isLogin")
                             ud.synchronize()
                         }
                     })
                 }
             }
    }
}
