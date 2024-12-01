//
//  GameTableViewCell.swift
//  saranggame
//
//  Created by MacBook on 23/11/24.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameReleasedDateLabel: UILabel!
    @IBOutlet weak var imageLoadIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gameImage.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
