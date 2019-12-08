//
//  DiaryTableViewCell.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/19.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit

protocol DiaryTableViewCellDelegate {
    func didTapSentenceButton(tableViewCell : UITableViewCell, button : UIButton)
    func didTapMenuButton(tableViewCell : UITableViewCell , button : UIButton)
}


class DiaryTableViewCell: UITableViewCell {
    
    var delegate : DiaryTableViewCellDelegate?
    
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var userImage : UIImageView!
    @IBOutlet var contentTextView : UITextView!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapSentenceButton(button : UIButton){
        self.delegate?.didTapSentenceButton(tableViewCell: self, button: button)
    }
    
    @IBAction func tapMenuButton(button : UIButton){
        self.delegate?.didTapMenuButton(tableViewCell: self, button: button)
    }
}
