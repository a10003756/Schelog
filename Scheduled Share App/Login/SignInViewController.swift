//
//  SignInViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/26.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var userIdTextField : UITextField!
    
    @IBOutlet var passwordTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    

    
    @IBAction func signIn(){
        
        if (userIdTextField.text?.count)! > 0 && (passwordTextField.text?.count)! > 0{
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text) { (user, error) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                }
            }
        }
        let ud = UserDefaults.standard
        ud.set(true, forKey: "isLogin")
        ud.synchronize()
    }
 

}
