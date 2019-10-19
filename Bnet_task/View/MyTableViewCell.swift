//
//  MyTableViewCell.swift
//  Bnet_task
//
//  Created by Tianid on 19.10.2019.
//  Copyright © 2019 Tianid. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var updatingDateLabel: UILabel!
    @IBOutlet weak var entryBodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
