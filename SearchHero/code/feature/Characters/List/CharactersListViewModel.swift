//
//  CharactersListViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import Foundation
import SwiftUI



@Observable
final class CharactersListViewModel:BaseViewModel  {
    
    var idCharacter:Int = 0
    
    let listCharactersLogic : ListCharactersLogic
    let charactersFavoriteLogic : CharactersFavoriteLogic
    let charactersReadLogic : CharactersReadLogic
    private var orderType:OrdenByType = .nameAZ
    private var isOrderByName:Bool = false
    private var isOrderByModified:Bool = false
    var searchData:Bool = false
    public var searchText:String = ""
    private var moreDataList:Int = 0
    var isMoreDataChager:Bool = false
    var isScrollTop:Bool = false
    var isDisplayView:Bool = false
    
    
    init(listCharactersLogic: ListCharactersLogic = ListCharactersLogic.sharer,charactersFavoriteLogic:CharactersFavoriteLogic = CharactersFavoriteLogic.sharer,charactersReadLogic:CharactersReadLogic = CharactersReadLogic.sharer) {
        self.listCharactersLogic = listCharactersLogic
        self.charactersFavoriteLogic = charactersFavoriteLogic
        self.charactersReadLogic = charactersReadLogic
    }

   
    
    override func displayProcessState(_ state:ProcessStateTypes) {
        DispatchQueue.main.async  {
            if state == .display {
                if self.listCharactersLogic.charactersList.isEmpty {
                    self.processState = .emptyDisplay
                    return
                }
                
            }
            self.processState = state
        }
    }
    
    
    func orderByNamelistCharacters() {
        Task {
            do {
                orderType = isOrderByName ? .nameAZ:.nameZA
                moreDataList = 0
                self.searchText = ""
                self.isOrderByName = !isOrderByName
                displayProcessState(.emptyDisplay)
                await fechlistCharactersData(offset: moreDataList,orderBy: orderType)
                self.isScrollTop.toggle()
            }
        }
    }
    
    func OrderByModifiedListCharacters() {
        Task {
            do {
                orderType = isOrderByModified ? .modifiedBottom : .modifiedTop
                moreDataList = 0
                self.searchText = ""
                self.isOrderByModified =  !isOrderByModified
                displayProcessState(.emptyDisplay)
                await fechlistCharactersData(offset: moreDataList,orderBy: orderType)
                self.isScrollTop.toggle()
            }
        }
    }
    
    func moreDataListCharacters() {
        Task {
            do {
                self.isMoreDataChager = false
                self.moreDataList += 1
                if listCharactersLogic.pagerTotal != listCharactersLogic.charactersList.count{
                    await fechlistCharactersData(offset: moreDataList,orderBy: orderType,nameStartsWith: searchText)
                }
                self.isMoreDataChager = true
            }
        }
    }
    
    
    func searchDataListCharacters(nameStartsWith:String) {
        Task {
            do {
                if searchText != nameStartsWith {
                    self.searchData = true
                    moreDataList = 0
                    displayProcessState(.emptyDisplay)
                    await fechlistCharactersData(offset: moreDataList,nameStartsWith: nameStartsWith)
                    self.searchText = nameStartsWith
                    self.isScrollTop.toggle()
                    self.searchData = false
                }
            }
        }
    }
    
    func resetDataListCharacters() {
        Task {
            do {
                self.moreDataList = 0
                self.searchText = ""
                displayProcessState(.emptyDisplay)
                await fechlistCharactersData(offset: moreDataList,orderBy: orderType)
            }
        }
    }
    
    func fechlistCharactersData(offset:Int = 0 ,orderBy:OrdenByType = .nameAZ,nameStartsWith:String = "") async {
        debugPrint("fechlistCharactersData")
        displayLoading(true)
        
        do {
            try await listCharactersLogic.fechListCharacters(offset:offset,orderBy: orderBy,nameStartsWith: nameStartsWith)
            displayLoading()
            displayProcessState(.display)
            self.isMoreDataChager = true
        } catch {
            displayLoading()
            displayProcessState(.emptyDisplay)
            displayAlertMessage(mesg: error.localizedDescription)
            debugPrint(error.localizedDescription)
        }
    }
   
}
