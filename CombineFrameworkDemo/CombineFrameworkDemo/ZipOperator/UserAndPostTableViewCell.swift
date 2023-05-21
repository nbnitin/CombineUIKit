//
//  UserAndPostTableViewCell.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 22/04/23.
//

import UIKit

class UserAndPostTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserAlbumNames: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
