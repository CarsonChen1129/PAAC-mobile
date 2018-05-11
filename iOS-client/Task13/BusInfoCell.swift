//
//  BusInfoCell.swift
//  Task13
//
//  Created by buqian zheng on 5/9/18.
//  Copyright © 2018 buqian zheng. All rights reserved.
//

import UIKit

class BusInfoCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var waitLocation: UILabel!
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(busInfo: BusInfo) {
        self.name.text = busInfo.name
        self.waitLocation.text = busInfo.waitLocation
        self.direction.text = busInfo.direction
        self.remainingTime.text = String(busInfo.remainingTime)
        self.selectionStyle = .none
    }

}
