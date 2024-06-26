//
//  CharacterSavedModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 20/6/24.
//

import Foundation


enum typeSavedModel:String {
    case favorite
    case story
}

struct CharacterSavedModel: Codable,Identifiable {
    var id: Int
    var name:String
    var type:String
    var url:String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case type
        case url
    }
}
