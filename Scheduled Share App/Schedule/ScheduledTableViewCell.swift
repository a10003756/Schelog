//
//  ScheduledTableViewCell.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/09/30.
//  Copyright © 2019 かなたまや. All rights reserved.

import UIKit
import NCMB

protocol ScheduledTableViewCellDelegate {
    func didTapMenuButton(tableViewCell : UITableViewCell , button : UIButton)  
}

class ScheduledTableViewCell: UITableViewCell ,UITextViewDelegate{
    
    var startDate = String()
    
    var delegate : ScheduledTableViewCellDelegate?
    
    @IBOutlet var startTimeLabel : UILabel!
    @IBOutlet var endTimeLabel : UILabel!
    @IBOutlet var titleTextView : UITextView!
    @IBOutlet var memoTextView : UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        titleTextView.delegate = self
        memoTextView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func openMenu(button : UIButton){
        self.delegate?.didTapMenuButton(tableViewCell: self, button: button)
    }
    
    
}
