//
//  FavoriteModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 20/6/24.
//

import Foundation

enum typeSavedModel {
    case favorite
    case story
}

struct CharacterSavedModel: Identifiable {
    var id: Int
    var name:String
    var type:typeSavedModel
    var url:String
}

