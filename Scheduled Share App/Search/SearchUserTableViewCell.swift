//
//  SearchUserTableViewCell.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/13.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit

protocol SearchUserTableViewCellDelegate {
    func didTapFollowButton(tableViewCell : UITableViewCell,  button : UIButton)
}

class SearchUserTableViewCell: UITableViewCell {
    
    var delegate : SearchUserTableViewCellDelegate?
  
    @IBOutlet var userNameLabel : UILabel!
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var followButton : UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func follow(button : UIButton){
        self.delegate?.didTapFollowButton(tableViewCell: self, button: button)
    }
    
}
