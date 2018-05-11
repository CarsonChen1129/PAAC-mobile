//
//  SearchInfoCell.swift
//  Task13
//
//  Created by buqian zheng on 5/10/18.
//  Copyright © 2018 buqian zheng. All rights reserved.
//

import UIKit
import QuartzCore

class SearchInfoCell: UITableViewCell {
    
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var stop: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var shadow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadow.layer.masksToBounds = false
        shadow.layer.shadowOffset = CGSize(width: -3, height: 3)
        shadow.layer.shadowRadius = 3
        shadow.layer.shadowOpacity = 0.3
        shadow.layer.cornerRadius = 5
        self.layer.backgroundColor = UIColor.clear.cgColor
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
