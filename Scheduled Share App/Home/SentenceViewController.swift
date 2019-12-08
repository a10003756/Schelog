//
//  SentenceViewController.swift
//  Scheduled Share App
//
//  Created by 櫻井春樹 on 2019/10/26.
//  Copyright © 2019 かなたまや. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher

protocol SentenceViewControllerDelegate {
    func didTapSentenceButton()
}

class SentenceViewController: UIViewController {
    
    var delegate : SentenceViewControllerDelegate?
    
    var selectedDiary : Diary!
    
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var userNameLabel : UILabel!
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var contentTextView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0

        // Do any additional setup after loading the view.
        loadDiary()
    }
    

    func loadDiary(){
        let user = selectedDiary.user
        let displayName = user.object(forKey: "displayName") as? String
        
        let image = "https://mbaas.api.nifcloud.com/2013-09-01/applications/VAirdJMPKVZ26nJL/publicFiles/" + user.objectId
        
        userImageView?.kf.setImage(with: URL(string: image))
        dateLabel.text = selectedDiary.date
        titleLabel.text = selectedDiary.title
        userNameLabel.text = displayName
        contentTextView.text = selectedDiary.content
    }

}
