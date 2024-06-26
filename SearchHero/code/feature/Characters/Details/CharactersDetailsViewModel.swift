//
//  CharactersDetailsViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation


@Observable
final class CharactersDetailsViewModel {
    
    var processState: ProcessStateTypes = .display
    var isLoading: Bool = false
    var isAlertbox: Bool = false
    var alertTitle:String = "Alerta"
    var alertMessage:String = ""
    var alertButton:String = "ok"
    
    
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

    func displayLoading(_ isLoading:Bool = false) {
        DispatchQueue.main.async  {
            self.isLoading = isLoading
        }
    }
    
    private func displayProcessState(_ state:ProcessStateTypes) {
        DispatchQueue.main.async  {
            self.processState = state
        }
    }
    
    func displayAlertMessage(title:String = "" ,mesg:String = "" ,textButton:String = "") {
        displayLoading()
        DispatchQueue.main.async  {
            self.isAlertbox = true
            if title != ""  {
                self.alertTitle = title
            }
            if mesg != ""  {
                self.alertMessage = mesg
            }
            
            if textButton != "" {
                self.alertButton = textButton
            }
        }
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
        displayLoading(true)
        
        do {
            let result = try await charactersLogic.fechCharactersComicsData(id: String(idCharacter))
            displayLoading()
            ComicsList = result
        } catch {
            displayLoading()
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
