//
//  CharacterModel.swift
//  Marvel
//
//  Created by Furkan Özyürek on 10.02.2022.
//

import Foundation
import ObjectMapper

struct CharacterModel: Mappable {
    
    var characterId: Int?
    var characterName: String?
    var characterImage: String?
    var characterImageExtension: String?
    var characterDescription: String?
    var comicList: [ComicModel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        characterId <- map["id"]
        characterName <- map["name"]
        characterImage <- map["thumbnail.path"]
        characterImageExtension <- map["thumbnail.extension"]
        comicList <- map["comics.items"]
        characterDescription <- map["description"]
    }
}
