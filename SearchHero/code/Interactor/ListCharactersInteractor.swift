//
//  ListCharactersInteractor.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation

protocol ListCharactersInteractor {
    func loadListCharacters(params:[String:String]) async throws -> BasesPagerModel<CharactersListResponse>
  
}
struct ListCharactersProvider: ListCharactersInteractor {
    func loadListCharacters(params:[String:String]) async throws -> BasesPagerModel<CharactersListResponse> {
        
        let requestModel = RequestModel(endpoint: .characters,queryItems: params)
        
        do{
            let model = try await ServiceLayer.callService(requestModel,BasesMarvelResponse<CharactersListResponse>.self)
            let listResponse = model.data
            return listResponse
        }catch{
            print(error)
            throw error
        }
    }
    
    
}
struct ListCharactersMock: ListCharactersInteractor {
    func loadListCharacters(params:[String:String]) async throws -> BasesPagerModel<CharactersListResponse> {
        
        let bundleURL: URL = Bundle.main.url(forResource: "ListCharacters", withExtension: "json")!
        let docURL: URL = URL.documentsDirectory.appending(path: "ListCharacters.json")
        
        var url = docURL
        if !FileManager.default.fileExists(atPath: url.path()) {
            url = bundleURL
        }
        
        do{
            let data = try Data(contentsOf: url)
            let model = try JSONDecoder().decode(BasesMarvelResponse<CharactersListResponse>.self, from: data)
            let listResponse = model.data
            return listResponse
        }catch{
            print(error)
            throw error
        }
    }
    
    
    
}
