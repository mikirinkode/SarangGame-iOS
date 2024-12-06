//
//  GenreTableViewCell.swift
//  saranggame
//
//  Created by MacBook on 24/11/24.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreCountLabel: UILabel!
    @IBOutlet weak var imageLoadIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageBackground.layer.cornerRadius = 16
    }
}
