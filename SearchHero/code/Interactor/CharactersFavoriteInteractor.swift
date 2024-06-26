//
//  CharactersFavoriteInteractor.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 23/6/24.
//

import Foundation

protocol CharactersFavoriteInteractor {
    var bundleURL:URL { get }
    var docURL:URL { get }
    func loadCharactersFavorite() throws -> [CharacterSavedModel]
    func saveCharactersFavorite(_ characterSaved:[CharacterSavedModel]) throws
}

extension CharactersFavoriteInteractor {
    func loadCharactersFavorite() throws -> [CharacterSavedModel] {
        var url = docURL
        if !FileManager.default.fileExists(atPath: url.path()) {
            url = bundleURL
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([CharacterSavedModel].self, from: data)
    }
    
    func saveCharactersFavorite(_ characterSaved: [CharacterSavedModel]) throws {
        let data = try JSONEncoder().encode(characterSaved)
        try data.write(to: docURL,options: .atomic)
    }
    
    
}

struct CharactersFavoriteProvider: CharactersFavoriteInteractor {
    var bundleURL: URL {
        Bundle.main.url(forResource: "FavoriteCharacters", withExtension: "json")!
    }
    
    var docURL: URL {
        URL.documentsDirectory.appending(path: "FavoriteCharacters.json")
    }
    
}
