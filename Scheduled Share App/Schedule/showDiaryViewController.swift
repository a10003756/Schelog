//
//  showDialyViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/29.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import NCMB
import SVProgressHUD

class showDiaryViewController: UIViewController ,UITextViewDelegate,UITextFieldDelegate{
    
    var diaries = [Diary]()

    var dateValue = String()
    
    var scheduled = [Scheduled]()
    
    @IBOutlet var dateTextField : UITextField!
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var contentTextView : UITextView!
//    @IBOutlet var diaryImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        contentTextView.placeholder = "日記内容"
        
        dateTextField.text = dateValue
        contentTextView.delegate = self
        
        showDiary()
        
        titleTextField.delegate = self
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextView.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

//    @IBAction func back(){
//        self.dismiss(animated: true, completion: nil)
//    }

    func showDiary(){
        let query = NCMBQuery(className: "Diary")
        query?.includeKey("date")
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("date", equalTo: dateValue)
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.diaries = [Diary]()
                for diaryObject in result as! [NCMBObject]{
                    let user = diaryObject.object(forKey: "user") as! NCMBUser
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    let date = diaryObject.object(forKey: "date") as! String
                    let title = diaryObject.object(forKey: "title") as! String
                    let content = diaryObject.object(forKey: "content") as! String
                    let diaryImage = diaryObject.object(forKey: "diaryImage") as? String
                    if diaryImage != nil {
                        let diary = Diary(objectId: diaryObject.objectId, user: user, date: date, title: title, content: content, image: diaryImage!, createDate: diaryObject.createDate)
                    self.titleTextField.text = title
                    self.contentTextView.text = content
                    } else {
                        let placeholder = "placeholder.jpg"
                        let diary = Diary(objectId: diaryObject.objectId, user: user, date: date, title: title, content: content, image: placeholder, createDate: diaryObject.createDate)
                        self.titleTextField.text = title
                        self.contentTextView.text = content
                        
                        
            }
                }
            }
        })
    
    }
}
