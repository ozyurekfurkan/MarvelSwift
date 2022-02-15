//
//  ComicDetailScreenVC.swift
//  Marvel
//
//  Created by Furkan Özyürek on 15.02.2022.
//

import UIKit
import Kingfisher

class ComicDetailScreenVC: UIViewController {

    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicDescription: UITextView!
    var data: ComicModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
    }
    
    func setupPage() {
        comicTitle.text = data?.title
        comicDescription.text = data?.description
        comicDescription.isSelectable = false
        comicDescription.isEditable = false
        if let imagePath = data?.imagePath, let imageExtension = data?.imageExtension {
            let formattedImageURL = "\(imagePath).\(imageExtension)"
            comicImage.kf.setImage(with: URL(string: formattedImageURL))
            comicImage.layer.cornerRadius = 10
        }
    }

}
