//
//  CellMessage.swift
//  Flash Chat
//
//  Created by mac on 15/3/2023.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class CellMessage: UITableViewCell {

    @IBOutlet weak var LabelView: UIView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var meAvatarImage: UIImageView!
    
    @IBOutlet weak var youAvatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        LabelView.layer.cornerRadius = LabelView.frame.size.height / 8
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
