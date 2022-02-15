//
//  DetailScreenVC.swift
//  Marvel
//
//  Created by Furkan Özyürek on 14.02.2022.
//

import UIKit
import Kingfisher
import ObjectMapper
import SpringIndicator

class DetailScreenVC: UIViewController {
    
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var segueIdentifier = "toComicDetailVC"
    var selectedIndex: Int?
    var comicCellId = "ComicCell"
    var characterId: String = ""
    
    var data: CharacterModel?
    var comicData = [ComicModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ComicCell.nib(), forCellReuseIdentifier: comicCellId)
        fetchData()
        DispatchQueue.main.async {
            self.setupPage()
        }
    }
    func fetchData() {
        let indicator = SpringIndicator(frame: CGRect(x: 100, y: 100, width: 60, height: 60))
                view.addSubview(indicator)
                indicator.center = self.tableView.center
                indicator.start()
        
        MarvelNetwork.makeRequest(target: .comicChar(id: characterId, apiKey: API_KEY, timeStamp: TIME_STAMP, hashKey: HASH_KEY), success: { (JSON) in
                            if let data = Mapper<ComicModel>().mapArray(JSONObject: JSON["data"]["results"].arrayObject) {
                                self.comicData = data
                                self.tableView.reloadData()
                                indicator.stop()

                            }
                                
        },statusCode: { (statusCode, statusMessage, requestForm) in
                indicator.stop()
        }, failure: { (moyaError) in
                indicator.stop()
        })
    }
    
    func setupPage() {
        characterName.text = data?.characterName
        characterImage.kf.setImage(with: (URL(string: "\(self.data?.characterImage ?? "").\(self.data?.characterImageExtension ?? "")")))
        characterImage.layer.cornerRadius = 20
        if let description = data?.characterDescription {
            if description != "" {
                characterDescription.text = description
            }
            else {
                characterDescription.text = "No information found about \(data?.characterName ?? "this character")"
            }
        }
    }
}
//MARK: - TableViewDelegate - TableViewDataSource
extension DetailScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: comicCellId, for: indexPath) as! ComicCell
        cell.comicTitle.text = self.comicData[indexPath.row].title
        if let imagePath = comicData[indexPath.row].imagePath, let imageExtension = comicData[indexPath.row].imageExtension {
            let formattedImageURL = "\(imagePath).\(imageExtension)"
            cell.comicImage.kf.setImage(with: URL(string: formattedImageURL))
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let comicDetailVC = segue.destination as! ComicDetailScreenVC
            if let selectedIndex = selectedIndex {
                comicDetailVC.data = self.comicData[selectedIndex]
            }
        }
    }
}
