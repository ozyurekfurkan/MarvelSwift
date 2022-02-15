//
//  HomeScreenVC.swift
//  Marvel
//
//  Created by Furkan Özyürek on 10.02.2022.
//

import UIKit
import ObjectMapper
import Kingfisher
import SpringIndicator

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var CHARACTER_NAME: String?
    let characterCellId = "CharacterCell"
    let segueIdentifier = "toCharacterDetailVC"
    var data = [CharacterModel]()
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
        self.view.backgroundColor = .black
        searchBar.barTintColor = .black
        self.tableView.backgroundColor = .black
        self.title = "Characters"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        searchBar.searchTextField.textColor = .white
        self.tableView.register(CharacterCell.nib(), forCellReuseIdentifier: characterCellId)
        fetchData()
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func fetchData() {
        let indicator = SpringIndicator(frame: CGRect(x: 100, y: 100, width: 60, height: 60))
                view.addSubview(indicator)
                indicator.center = self.view.center
                indicator.start()
        
        MarvelNetwork.makeRequest(target: .marvelChar(apiKey: API_KEY, timeStamp: TIME_STAMP, hashKey: HASH_KEY , name: CHARACTER_NAME), success: { (JSON) in
                if let data = Mapper<CharacterModel>().mapArray(JSONObject: JSON["data"]["results"].arrayObject) {
                    self.data = data
                    self.tableView.reloadData()
                    indicator.stop()
                }
                    }, statusCode: { (statusCode, statusMessage, requestForm) in
                        indicator.stop()
                    }, failure: { (moyaError) in
                        indicator.stop()
            })
    }
}
//MARK: - TableViewDelegate - TableViewDataSource
extension HomeScreenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: characterCellId, for: indexPath) as! CharacterCell
        if let characterImage = data[indexPath.row].characterImage, let characterImageExtension = data[indexPath.row].characterImageExtension {
            let formattedImageURL = "\(characterImage).\(characterImageExtension)"
            cell.characterImage.kf.setImage(with: URL(string: formattedImageURL))
        }
        cell.characterName.text = self.data[indexPath.row].characterName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let detailPageVC = segue.destination as! DetailScreenVC
            if let selectedIndex = selectedIndex {
                detailPageVC.data = self.data[selectedIndex]
                detailPageVC.characterId = String(self.data[selectedIndex].characterId!)
            }
            
        }
    }
}
//MARK: - UISearchBarDelegate
extension HomeScreenVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText != "" {
                CHARACTER_NAME = searchText
                fetchData()
            }
        }
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true {
            CHARACTER_NAME = nil
            fetchData()
        }
    }
}
