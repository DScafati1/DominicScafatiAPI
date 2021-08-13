//
//  MoviesTableViewCell.swift
//  DominicScafatiAPI
//
//  Created by Dom Scafati on 8/13/21.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMovieData(movie:(title:String, year:String, posterUrl:String)) {
        let url = URL(string:movie.posterUrl)
        posterImageView.kf.setImage(with: url)
        lblName.text = movie.title
        lblYear.text = movie.year
    }

}
