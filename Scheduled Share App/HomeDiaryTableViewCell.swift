//
//  HomeDailyTableViewCell.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/13.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit

class HomeDiaryTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var userNameLabel : UILabel!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var diaryTextView : UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
