//
//  UserViewCell.swift
//  Phonebook
//
//  Created by GGsrvg on 09.06.2020.
//  Copyright © 2020 GGsrvg. All rights reserved.
//

import UIKit
import Dante

class UserViewCell: UITableViewCell {

    @IBOutlet private weak var naturalImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(imageUrl: String, firstName: String, lastName: String, secondName: String){
        naturalImageView.loadImage(imageUrl)
        
        nameLabel.text = "\(lastName) \(firstName) \(secondName)"
    }
    
}
