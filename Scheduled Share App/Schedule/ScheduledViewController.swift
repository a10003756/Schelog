//
//  ScheduledViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/28.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB


class ScheduledViewController: UIViewController, UITextFieldDelegate{
    
    let datePicker = UIDatePicker()
    
    @IBOutlet var startDateTextField : UITextField!
    @IBOutlet var startTimeTextField : UITextField!
    @IBOutlet var endDateTextField : UITextField!
    @IBOutlet var endTimeTextField : UITextField!
    @IBOutlet var scheduledContentTextField : UITextField!
    @IBOutlet var memoTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        scheduledContentTextField.delegate = self
        memoTextField.delegate = self
        
        startDateTextField.text = dateValue
        endDateTextField.text = dateValue
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textFieldのreturnキーを押した時の処理
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func back(){
        //backボタンを押した時の処理
        self.dismiss(animated: true, completion: nil)
    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
    //textFieldを編集開始した時の処理
//        print(startTimeTextField.text)
//        dateEditting(sender: startTimeTextField)
//        dateEditting(sender: endTimeTextField)

//    }

    
//    func dateEditting(sender : UITextField){
//        //datePicker内の設定
//        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
//        datePicker.locale         = NSLocale(localeIdentifier: "ja_JP") as Locale
//        sender.inputView          = datePicker
//        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
//
//        let okButton = UIButton()
//        okButton.setTitle("OK", for: .normal)
//        okButton.addTarget(datePicker, action: #selector(ViewController.dismiss(animated:completion:)), for: UIControl.Event.touchUpInside)
//    }
    
//    @objc func datePickerValueChanged() {
//    //datePickeの値が変わった時の処理
//        startTimeTextField.text = DateUtils.stringFromDate(date: datePicker.date, format: "MM月dd日h時m分")
//        endTimeTextField.text = DateUtils.stringFromDate(date: datePicker.date, format: "MM月dd日h時m分")
//
//    }
    
    
    
    @IBAction func save(){
        //保存ボタンを押した時の処理
        let scheduledObject = NCMBObject(className: "Scheduled")
        scheduledObject?.setObject(startDateTextField.text, forKey: "startDateScheduled")
        scheduledObject?.setObject(startTimeTextField.text, forKey: "startScheduledTime")
        scheduledObject?.setObject(endDateTextField.text, forKey: "endDateScheduled")
        scheduledObject?.setObject(endTimeTextField.text, forKey: "endScheduledTime")
        scheduledObject?.setObject(scheduledContentTextField.text, forKey: "scheduledContent")
        scheduledObject?.setObject(memoTextField.text, forKey: "memo")
        scheduledObject?.setObject(NCMBUser.current(), forKey: "user")
        scheduledObject?.saveInBackground({ (error) in
            if error != nil{
                let alert = UIAlertController(title: "エラー", message: "予期せぬエラーが起こりました", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    if ( UI_USER_INTERFACE_IDIOM() == .pad ){
                             let screenSize = UIScreen.main.bounds
                        alert.popoverPresentationController?.sourceView = self.view
                             alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
                    self.present(alert, animated: true, completion: nil)
                    } else {
                        self.present(alert, animated: true, completion: nil
                        )
                    }
                })
            } else {
                self.dismiss(animated: true, completion: nil)
                
            }
        })
    }

}

class DateUtils {
    //date型からstring型への変換
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    class func stringFromDate(date: Date, format: String) -> String {
        //string型からdate型への変換
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    

}
