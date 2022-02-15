//
//  ComicCell.swift
//  Marvel
//
//  Created by Furkan Özyürek on 14.02.2022.
//

import UIKit

class ComicCell: UITableViewCell {

    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ComicCell", bundle: nil)
    }

    
}
