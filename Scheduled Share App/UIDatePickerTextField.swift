//
//  UiDatePickerTextField.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/29.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit

class UiDatePickerTextField: UITextField {
    
    var datePicker: UIDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFocused), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    @objc func handleFocused(notification: NSNotification!) {
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "ja_PP") as Locale
        //UITextField の inputView のプロパティに UIDatePicker を設定
        self.inputView = datePicker
        
        // UIToolbar の設定
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 200, y: 0, width: frame.size.width, height: 35))
        let cancel2 =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([cancel2, doneItem], animated: true)
        
        
        // UITextField の inputAccessoryView のプロパティに UIToolbar を設定
        self.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        super.text = dateFormatter.string(from: sender.date)
    }
    
    
    @objc func cancelButton() {
        super.text = ""
        super.endEditing(true)
    }
    
    @objc func done() {
        // 日付のフォーマット
        let formatter = DateFormatter()
        
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
        formatter.dateFormat = "yyyy年MM月d日"
        
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        super.text = "\(formatter.string(from: datePicker.date))"
        
        super.endEditing(true)
    }
    
    
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        super.resignFirstResponder()
    }
    
}
