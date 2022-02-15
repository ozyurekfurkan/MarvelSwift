//
//  ComicModel.swift
//  Marvel
//
//  Created by Furkan Özyürek on 10.02.2022.
//

import Foundation
import ObjectMapper

struct ComicModel: Mappable {
    var title: String?
    var imagePath: String?
    var imageExtension: String?
    var description: String?
    var id: Int?
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        id <- map["id"]
        description <- map["description"]
        imagePath <- map["thumbnail.path"]
        imageExtension <- map["thumbnail.extension"]
    }
}
