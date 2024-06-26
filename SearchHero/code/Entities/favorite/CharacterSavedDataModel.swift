//
//  CharacterSavedDataModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 25/6/24.
//

import Foundation
import SwiftData

@Model
class CharacterSavedDataModel {
    @Attribute(.unique) var id: Int
    var name:String
    var type:String
    var url:String
    var position:Int
 
    init(id: Int, name: String, type: String, url: String,position:Int) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
        self.position = position
    }
}
