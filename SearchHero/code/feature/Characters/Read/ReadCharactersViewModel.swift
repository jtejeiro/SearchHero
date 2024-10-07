//
//  ReadCharactersViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 1/7/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class ReadCharactersViewModel: BaseViewModel {
    let readLogic : CharactersReadLogic

    init(readLogic:CharactersReadLogic = CharactersReadLogic.sharer) {
        self.readLogic = readLogic
    }
    
    func fechReadData() async {
        debugPrint("fechlistCharactersData")
        displayLoading(true)
        await self.readLogic.getCharacterSavedDataModel()
        
        if self.readLogic.charactersReadList.isEmpty {
            displayProcessState(.emptyDisplay)
            displayLoading()
            return
        }
        
        displayProcessState(.display)
        displayLoading()
    }
    
}

