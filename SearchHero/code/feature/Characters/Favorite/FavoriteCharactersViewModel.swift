//
//  FavoriteCharactersViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 28/6/24.
//

import Foundation
import SwiftUI

@Observable
final class FavoriteCharactersViewModel: BaseViewModel {
    
    let favoriteLogic : CharactersFavoriteLogic
    
    init(charactersFavoriteLogic:CharactersFavoriteLogic = CharactersFavoriteLogic.sharer) {
        self.favoriteLogic = charactersFavoriteLogic
    }

    
    func fechFavoriteData() async {
        debugPrint("fechlistCharactersData")
        displayLoading(true)
        
        if self.favoriteLogic.charactersSavedList.isEmpty {
            self.processState = .emptyDisplay
            displayLoading()
            return
        }
        
        displayProcessState(.display)
        displayLoading()
    }
    
}
