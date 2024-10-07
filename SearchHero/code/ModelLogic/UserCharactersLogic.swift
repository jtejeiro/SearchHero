//
//  UserCharactersLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 5/7/24.
//

import Foundation
import SwiftData

@Observable
final class UserCharactersLogic:DatabaseService {
    static let sharer = UserCharactersLogic()
    var userCharactersModel : [UserCharactersModel]
    
    
    @MainActor
    func getUserCharactersModel() {
        let fetchDescriptor = FetchDescriptor<UserCharactersModel>(predicate: nil,
                                                                   sortBy: [SortDescriptor<UserCharactersModel>(\.createData,order: .reverse)])
        userCharactersModel = try! modelContext.fetch(fetchDescriptor)
        
        print(userCharactersModel)
    }
    
    @MainActor
    func insert(model:UserCharactersModel) {
        modelContext.insert(model)
        try? modelContext.save()
        userCharactersModel = []
        getUserCharactersModel()
    }
    
    @MainActor
    func deleteAllData() {
        userCharactersModel.forEach { model in
            modelContext.delete(model)
        }
        try? modelContext.save()
        userCharactersModel = []
        getUserCharactersModel()
    }
    
    override init() {
        self.userCharactersModel =  []
    }
    
    
    @MainActor
    func removeIdUserCharactersModel(id:Int){
        userCharactersModel.forEach { model in
            if model.id == id {
                modelContext.delete(model)
            }
        }
        try? modelContext.save()
        userCharactersModel = []
        getUserCharactersModel()
    }
}

