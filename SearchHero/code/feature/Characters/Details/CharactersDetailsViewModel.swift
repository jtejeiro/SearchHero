//
//  CharactersDetailsViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation


@Observable
final class CharactersDetailsViewModel:BaseViewModel { 
    
    let charactersLogic : CharactersLogic
    let charactersFavoriteLogic : CharactersFavoriteLogic
    let charactersReadLogic : CharactersReadLogic
    var charactersData : CharactersListResponse?
    var ComicsList : [ComicsListResponse]?
    
    let idCharacter:Int
    
    init(idCharacter:Int,_ charactersLogic: CharactersLogic = CharactersLogic.sharer, charactersFavoriteLogic:CharactersFavoriteLogic = CharactersFavoriteLogic.sharer,charactersReadLogic:CharactersReadLogic = CharactersReadLogic.sharer) {
        self.idCharacter = idCharacter
        self.charactersLogic = charactersLogic
        self.charactersReadLogic = charactersReadLogic
        self.charactersFavoriteLogic = charactersFavoriteLogic
    }

   
    
    func fechCharactersData() async {
        debugPrint("fechCharactersData")
        displayLoading(true)
        
        do {
            let result = try await charactersLogic.fechCharactersData(id: String(idCharacter))
            displayLoading()
            displayProcessState(.display)
            charactersData = result
        } catch {
            displayLoading()
            displayProcessState(.emptyDisplay)
            displayAlertMessage(mesg: error.localizedDescription)
            debugPrint(error.localizedDescription)
        }
    }
    
    func fechComicsListData() async {
        debugPrint("fechComicsList")
        
        do {
            let result = try await charactersLogic.fechCharactersComicsData(id: String(idCharacter))
            ComicsList = result
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getIsUrlCharactersData() -> Bool {
        guard (charactersData?.urls) != nil else {
            return false
        }
        
        return true
    }

}
