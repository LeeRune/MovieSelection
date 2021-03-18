//
//  MovieTableViewCell.swift
//  MovieSelection
//
//  Created by 李易潤 on 2021/3/2.
//

import UIKit

class MovieTVC: UITableViewCell {

    @IBOutlet weak var tmbdVote: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
