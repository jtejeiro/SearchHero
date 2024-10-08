//
//  CharactersReadLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 22/6/24.
//

import Foundation
import SwiftData

@Observable
final class CharactersReadLogic:DatabaseService {
    static let sharer = CharactersReadLogic()
    var charactersReadList : [CharacterSavedDataModel]
    
    @MainActor
    func getCharacterSavedDataModel() {
        let fetchDescriptor = FetchDescriptor<CharacterSavedDataModel>(predicate: nil,
                                                                       sortBy: [SortDescriptor<CharacterSavedDataModel>(\.position)])
        charactersReadList = try! modelContext.fetch(fetchDescriptor)
        
        print(charactersReadList)
    }
    
    @MainActor
    func insert(model:CharacterSavedDataModel) {
        modelContext.insert(model)
        charactersReadList = []
        getCharacterSavedDataModel()
    }
    
    @MainActor
    func deleteAllData() {
        charactersReadList.forEach { model in
            modelContext.delete(model)
        }
        try? modelContext.save()
        charactersReadList = []
        getCharacterSavedDataModel()
    }
    
    override init() {
        self.charactersReadList =  []
    }
    
    @MainActor
    func savedReadCharaCharacters(model:CharactersListResponse){
        if isReadCharaCharacters(id: model.id) {
            removeIdReadCharaCharacters(id: model.id)
        }
        
        self.insert(model: CharacterSavedDataModel(id: model.id, name: model.name, type: typeSavedModel.story.rawValue, url: model.thumbnail?.getTThumbnailUrl ?? ""))
    }
    
    @MainActor
    func clickSavedReadCharaCharacters(model:CharactersListResponse){
        if isReadCharaCharacters(id: model.id) {
            removeIdReadCharaCharacters(id: model.id)
            return
        }
        
        self.insert(model: CharacterSavedDataModel(id: model.id, name: model.name, type: typeSavedModel.story.rawValue, url: model.thumbnail?.getTThumbnailUrl ?? ""))
    }
    
    func isReadCharaCharacters(id:Int) -> Bool{
        return charactersReadList.contains { model in
            model.id == id
        }
    }
    
    @MainActor
    func removeIdReadCharaCharacters(id:Int){
        charactersReadList.forEach { model in
            if model.id == id {
                modelContext.delete(model)
            }
        }
        try? modelContext.save()
        charactersReadList = []
        getCharacterSavedDataModel()
    }
}
