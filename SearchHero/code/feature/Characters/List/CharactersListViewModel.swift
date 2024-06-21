//
//  CharactersListViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import Foundation
import SwiftUI

enum ProcessStateTypes {
    case display
    case emptyDisplay
}

@Observable
final class CharactersListViewModel {
    
    var processState: ProcessStateTypes
    var isLoading: Bool = false
    var isAlertbox: Bool = false
    var alertTitle:String = "Alerta"
    var alertMessage:String = "Habido un error en el Sistema"
    var alertButton:String = "ok"
    var idCharacter:Int = 0
    
    
    let listCharactersLogic : ListCharactersLogic
    var charactersList : [CharactersListResponse]
    private var orderType:OrdenByType = .nameAZ
    private var isOrderByName:Bool = false
    private var isOrderByModified:Bool = false
    var searchData:Bool = false
    public var searchText:String = ""
    private var moreDataList:Int = 0
    var isMoreDataChager:Bool = false
    var isScrollTop:Bool = false
    
    
    init(listCharactersLogic: ListCharactersLogic = ListCharactersLogic.sharer) {
        self.listCharactersLogic = listCharactersLogic
        self.charactersList = []
        self.processState = .display
    }

    func displayLoading(_ isLoading:Bool = false) {
        DispatchQueue.main.async  {
            self.isLoading = isLoading
        }
    }
    
    private func displayProcessState(_ state:ProcessStateTypes) {
        DispatchQueue.main.async  {
            if state == .display {
                if self.charactersList.isEmpty {
                    self.processState = .emptyDisplay
                    return
                }
                
            }
            
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
                if listCharactersLogic.pagerTotal != charactersList.count{
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
            let result = try await listCharactersLogic.fechListCharacters(offset:offset,orderBy: orderBy,nameStartsWith: nameStartsWith)
            displayLoading()
            displayProcessState(.display)
            self.isMoreDataChager = true
            charactersList = result
        } catch {
            displayLoading()
            displayProcessState(.emptyDisplay)
            displayAlertMessage(mesg: error.localizedDescription)
            debugPrint(error.localizedDescription)
        }
    }
    
   
}
