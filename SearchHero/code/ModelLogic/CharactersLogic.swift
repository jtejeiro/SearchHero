//
//  CharactersLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation

enum EndpointsAtribute : String   {
    case characters
    case comics
    case events
    case series
    case stories
    case empty
}

@Observable
final class CharactersLogic {
    static let sharer = CharactersLogic()
    var charactersData : CharactersListResponse
    var comicsListData : [ComicsListResponse]
    let interactor : CharactersInteractor
   
    init(_ interactor: CharactersInteractor = CharactersProvider()) {
        self.charactersData = CharactersListResponse(id: 0, name: "", resultDescription: "")
        self.comicsListData = []
        self.interactor = interactor
    }
    
    
    func fechCharactersData(id:String) async throws -> CharactersListResponse {
        do {
            let model = try await interactor.loadCharacters(id: id)
            charactersData = model
            return charactersData
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
    func fechCharactersComicsData(id:String) async throws -> [ComicsListResponse] {
        do {
            let model = try await interactor.loadCharactersComics(id: id)
            comicsListData = model
            return comicsListData
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
}
