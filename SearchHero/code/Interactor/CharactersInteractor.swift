//
//  CharactersInteractor.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation

protocol CharactersInteractor {
    func loadCharacters(id:String) async throws -> CharactersListResponse
    func loadCharactersComics(id:String) async throws -> [ComicsListResponse]

}
struct CharactersProvider: CharactersInteractor {
    func loadCharactersComics(id: String) async throws -> [ComicsListResponse] {
        let requestModel = RequestModel(endpoint: .characters,endpointsAtribute: .comics, queryparam: id)
        
        do{
            let model = try await ServiceLayer.callService(requestModel,BasesMarvelResponse<ComicsListResponse>.self)
            let response = model.data.results
            return response
        }catch{
            print(error)
            throw error
        }
    }
    
    
    func loadCharacters(id:String) async throws -> CharactersListResponse {
        
        let requestModel = RequestModel(endpoint: .characters,queryparam: id)
        
        do{
            let model = try await ServiceLayer.callService(requestModel,BasesMarvelResponse<CharactersListResponse>.self)
            if let response = model.data.results.first {
                return response
            }
            throw NetworkError.jsonDecoder
        }catch{
            print(error)
            throw error
        }
    }
    
}

struct CharactersMock: CharactersInteractor {
    func loadCharactersComics(id: String) async throws -> [ComicsListResponse] {
        let requestModel = RequestModel(endpoint: .characters,endpointsAtribute: .comics, queryparam: id)
        
        do{
            let model = try await ServiceLayer.callService(requestModel,BasesMarvelResponse<ComicsListResponse>.self)
            let response = model.data.results
            return response
        }catch{
            print(error)
            throw error
        }
    }
    
    
    func loadCharacters(id:String) async throws -> CharactersListResponse {
        
        let bundleURL: URL = Bundle.main.url(forResource: "CharacterMock", withExtension: "json")!
        let docURL: URL = URL.documentsDirectory.appending(path: "CharacterMock.json")
        
        var url = docURL
        if !FileManager.default.fileExists(atPath: url.path()) {
            url = bundleURL
        }
        
        do{
            let data = try Data(contentsOf: url)
            let model = try JSONDecoder().decode(BasesMarvelResponse<CharactersListResponse>.self, from: data)
            if let response =  model.data.results.first {
                return response
            }
            throw NetworkError.jsonDecoder
        }catch{
            print(error)
            throw error
        }
    }
    
}
