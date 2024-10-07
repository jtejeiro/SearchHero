//
//  UserCharactersModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 2/7/24.
//
import Foundation
import SwiftData

@Model
class UserCharactersModel {
    @Attribute(.unique) var id: Int
    var heroName:String
    var originalName:String
    var cityDefeder:String
    var typePower:String
    var createData:Date
    
    init(id: Int, heroName: String, originalName: String, cityDefeder: String,typePower:String) {
        self.id = id
        self.heroName = heroName
        self.originalName = originalName
        self.cityDefeder = cityDefeder
        self.typePower = typePower
        self.createData = Date.now
    }
}

