//
//  FirstViewControlleViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/11/14.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class FirstViewControlleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var userNameTextField : UITextField!
    @IBOutlet var userIdTextField : UITextField!
    @IBOutlet var introductionTextView : UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     @IBAction func selectedImage(){
            let alert = UIAlertController(title: "画像選択", message: "画像を選んで下さい", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    
                    self.present(picker, animated: true, completion: nil)
            }
        }
            let photoLibraryAction = UIAlertAction(title: "写真を選ぶ", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
                }
            }
            
            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAlert)
            alert.addAction(cameraAction)
            alert.addAction(photoLibraryAction)
            if ( UI_USER_INTERFACE_IDIOM() == .pad ){
                     let screenSize = UIScreen.main.bounds
                     alert.popoverPresentationController?.sourceView = view
                     alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
            self.present(alert, animated: true, completion: nil)
            } else {
                self.present(alert, animated: true, completion: nil)
            }
    }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let resizedImage = selectedImage.scale(byFactor: 0.4)
            
            userImageView.image = selectedImage
            picker.dismiss(animated: true , completion: nil)
            
            let data = resizedImage?.pngData()
            let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data) as! NCMBFile
            file.saveInBackground({ (error) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                }else {
                    self.userImageView.image = selectedImage
                }
            }) { (progress) in
                
                
            }
        }
        
        @IBAction func complete(){
            let user = NCMBUser.current()
            user?.setObject(userNameTextField.text, forKey: "displayName")
            user?.setObject(userIdTextField.text, forKey: "userName")
            user?.setObject(introductionTextView.text, forKey: "introduction")
            user?.saveInBackground({ (error) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
            self.performSegue(withIdentifier: "RootViewController", sender: nil)
        }
        
        
        func loadUserInfo(){
            
            if let user = NCMBUser.current() {
                let userName = user.object(forKey: "userName") as! String
                let displayName = user.object(forKey: "displayName") as? String
               
                let introduction = user.object(forKey: "introduction") as? String
    //            let userImage = "https://mbaas.api.nifcloud.com/2013-09-01/applications/VAirdJMPKVZ26nJL/publicFiles/" + user.objectId
                print("=======")
    //            print(userImage)
                
                let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
                   file.getDataInBackground { (data, error) in
                    if error != nil{
                    } else {
                           if data != nil{
                               let image = UIImage(data: data!)
                               self.userImageView.image = image
                           }
                       }
                   }
                
                userNameTextField.text = displayName
                userIdTextField.text = userName
                introductionTextView.text = introduction
                
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
