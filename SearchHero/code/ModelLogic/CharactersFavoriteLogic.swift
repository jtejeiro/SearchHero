//
//  CharactersFavoriteLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 21/6/24.
//

import Foundation

@Observable
final class CharactersFavoriteLogic {
    static let sharer = CharactersFavoriteLogic()
    var charactersSavedList : [CharacterSavedModel]
    let limited:Int = 3
    let interactor : CharactersFavoriteInteractor
    
    init(_ interactor: CharactersFavoriteInteractor = CharactersFavoriteProvider()) {
        self.interactor = interactor
        do {
            self.charactersSavedList = try  interactor.loadCharactersFavorite()
        } catch {
            debugPrint(error)
            self.charactersSavedList = []
        }
    }
    
    func savedFavoriteCharaCharacters(model:CharactersListResponse){
        if isFavoriteCharaCharacters(id: model.id) {
            removeIdFavoriteCharaCharacters(id: model.id)
            return
        }
            charactersSavedList.append(CharacterSavedModel(id: model.id, name: model.name, type: typeSavedModel.favorite.rawValue, url: model.thumbnail?.getTThumbnailUrl ?? ""))
        saveCharactersFavorite()
    }
    
    func isFavoriteCharaCharacters(id:Int) -> Bool{
        return charactersSavedList.contains { model in
            model.id == id
        }
    }
    
    func removeIdFavoriteCharaCharacters(id:Int){
        charactersSavedList.removeAll { model in
            model.id == id
        }
        saveCharactersFavorite()
    }
     
    private func saveCharactersFavorite() {
        do {
            try interactor.saveCharactersFavorite(charactersSavedList)
        } catch {
            debugPrint(error)
        }
    }
}
