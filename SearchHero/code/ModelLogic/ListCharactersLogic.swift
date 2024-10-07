//
//  ListCharactersLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation

import Foundation

enum OrdenByType: String, CodingKey {
     case nameAZ = "name"
     case nameZA = "-name"
     case modifiedTop = "modified"
     case modifiedBottom = "-modified"
}

enum pagerParamerterKey: String, CodingKey  {
    case limit
    case offset
    case orderBy
    case nameStartsWith
}

@Observable
final class ListCharactersLogic {
    static let sharer = ListCharactersLogic()
    private let interactor : ListCharactersInteractor
    var charactersList : [CharactersListResponse]
    var pagerTotal:Int = 0
    let limitValue:Int = 20
    var nameStartsWithValue:String = ""

   
    
    init(_ interactor: ListCharactersInteractor = ListCharactersProvider()){
        self.interactor = interactor
        self.charactersList = []
    }
    
    func fechListCharacters(offset:Int = 0,orderBy:OrdenByType = .nameAZ,nameStartsWith:String = "") async throws {
        let numberOffset = offset != 0 ? limitValue * offset:0
        
        var params = [pagerParamerterKey.offset.rawValue:String(numberOffset)]
        params[pagerParamerterKey.limit.rawValue] = String(limitValue)
        
        if nameStartsWith != "" {
            params[pagerParamerterKey.nameStartsWith.rawValue] = nameStartsWith
        }else {
            
            params[pagerParamerterKey.orderBy.rawValue] = orderBy.rawValue
        }
        
        
        do {
            let model = try await interactor.loadListCharacters(params: params)
            pagerTotal = model.total
            if offset != 0 && nameStartsWith != "" {
                await MainActor.run{
                    charactersList.append(contentsOf: model.results)
                }
            } else if offset != 0 && nameStartsWith == "" {
                await MainActor.run{
                    charactersList.append(contentsOf: model.results)
                }
            }else {
                if !charactersList.isEmpty {
                    charactersList.removeAll()
                }
                await MainActor.run{
                    charactersList = model.results
                }
            }
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
  
    
}
