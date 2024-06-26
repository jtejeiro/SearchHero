//
//  CharactersReadLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 22/6/24.
//

import Foundation
import SwiftData

@Observable
final class CharactersReadLogic {
    static let sharer = CharactersReadLogic()
    let container = try! ModelContainer(for: CharacterSavedDataModel.self)
    var charactersReadList : [CharacterSavedDataModel]
    let limited:Int = 3
    var isRefresh:Bool = false
    var position:Int = 0
    
    @MainActor
    var modelContext:ModelContext {
        container.mainContext
    }
    
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
        position = 0
        charactersReadList.forEach { model in
            modelContext.delete(model)
        }
        try? modelContext.save()
        charactersReadList = []
        getCharacterSavedDataModel()
    }
    
    init() {
        self.charactersReadList =  []
    }
    
    @MainActor
    func savedReadCharaCharacters(model:CharactersListResponse){
        if isReadCharaCharacters(id: model.id) {
            removeIdReadCharaCharacters(id: model.id)
        }
        
        self.insert(model: CharacterSavedDataModel(id: model.id, name: model.name, type: typeSavedModel.story.rawValue, url: model.thumbnail?.getTThumbnailUrl ?? "", position: <#Int#>))
    }
    
    @MainActor
    func clickSavedReadCharaCharacters(model:CharactersListResponse){
        if isReadCharaCharacters(id: model.id) {
            removeIdReadCharaCharacters(id: model.id)
            return
        }
        
        self.insert(model: CharacterSavedDataModel(id: model.id, name: model.name, type: typeSavedModel.story.rawValue, url: model.thumbnail?.getTThumbnailUrl ?? "", position: position))
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
