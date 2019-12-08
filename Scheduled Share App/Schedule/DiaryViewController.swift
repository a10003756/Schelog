//
//  DialyViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/27.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB
import UITextView_Placeholder
import SVProgressHUD

class DiaryViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate{
    
    var diary = [Diary]()
    let datePicker = UIDatePicker()
    var resizedImage : UIImage!
    let placeholder = UIImage(named: "placeholder.jpg")
    
    @IBOutlet var dateTextField : UITextField!
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var contentTextView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        dateTextField.delegate = self
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        dateTextField.text = dateValue
        
        contentTextView.placeholder = "日記内容"
//        diaryImageView.image = UIImage(named: "placeholder.jpg")
        
        contentTextView.layer.borderColor = UIColor.gray.cgColor
        contentTextView.layer.borderWidth = 1.0
        dateDuplicate()
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func back(){
        //戻るボタンを押した時の処理
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedImage(){
        //画像選択ボタンを押した時の処理
        let alert = UIAlertController(title: "画像選択", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil )
            }
        }
        let libraryAction = UIAlertAction(title: "ライブラリから選ぶ", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
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
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        //ライブラリ内の画像を選択した時の処理
//        picker.dismiss(animated: true, completion: nil)
//        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        resizedImage = selectedImage.scale(byFactor: 0.4)
//        diaryImageView.image = resizedImage
//    }
//
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textFieldで編集を開始した時の関数
        dateEditting(sender: dateTextField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dateDuplicate()
    }
    
    @objc func datePickerValueChanged() {
        let formatter = DateFormatter()
        //        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as! Locale
        dateTextField.text = DateUtils.stringFromDate(date: datePicker.date, format: "yyyy年MM月dd日")
    }
    
    func dateEditting(sender : UITextField){
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.locale         = NSLocale(localeIdentifier: "ja_JP") as Locale
        sender.inputView          = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        //textView内でreturnキー押した時の処理
        textView.resignFirstResponder()
        return true
    }
    
//
//
    @IBAction func save(){
        
        let scheduledObject = NCMBObject(className: "Diary")
        let query = NCMBQuery(className: "Diary")
        query?.whereKey("date", equalTo: dateValue)
//        query?.whereKey("date", notEqualTo: )
        
        query?.getFirstObjectInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                if result != nil {
                let object = result as! NCMBObject
                let objectId = object.object(forKey: "objectId") as! String
                scheduledObject?.objectId = objectId
        
        scheduledObject?.fetchInBackground({ (error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                scheduledObject?.setObject(self.contentTextView.text, forKey: "content")
                scheduledObject?.setObject(self.dateTextField.text, forKey: "date")
                scheduledObject?.setObject(self.titleTextField.text, forKey: "title")
                scheduledObject?.setObject(NCMBUser.current(), forKey: "user")

                scheduledObject?.saveInBackground({ (error) in
                          if error != nil{
                          } else {
                              self.dismiss(animated: true, completion: nil)
                              return
                          }
                      })
            }
        })
                } else {
                    scheduledObject?.setObject(self.contentTextView.text, forKey: "content")
                    scheduledObject?.setObject(self.dateTextField.text, forKey: "date")
                    scheduledObject?.setObject(self.titleTextField.text, forKey: "title")
                    scheduledObject?.setObject(NCMBUser.current(), forKey: "user")
                    
                    scheduledObject?.saveInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
        }
        })
    }
            

    
    func dateDuplicate(){
        
        let query = NCMBQuery(className: "Diary")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("date", equalTo: self.dateTextField.text)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                for follows in result as! [NCMBObject]{
                    let title = follows.object(forKey: "title") as! String
                    let content = follows.object(forKey: "content") as! String
                    self.titleTextField.text = title
                    self.contentTextView.text = content
                }
            }
        })
    }
    
}

