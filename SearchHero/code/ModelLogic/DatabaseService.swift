//
//  DatabaseService.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 8/7/24.
//

import Foundation

import SwiftData

@Observable
class DatabaseService {
    let container = try! ModelContainer(for: UserCharactersModel.self,CharacterSavedDataModel.self )
    
    @MainActor
    var modelContext:ModelContext {
        container.mainContext
    }
}
