//
//  TypePowerInteractor.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 7/7/24.
//

import Foundation

protocol TypePowerInteractor {
    var bundleURL:URL { get }
    var docURL:URL { get }
    func loadTypePowerData() throws -> [TypePowerModel]
}

extension TypePowerInteractor {
    func loadTypePowerData() throws -> [TypePowerModel] {
        var url = docURL
        if !FileManager.default.fileExists(atPath: url.path()) {
            url = bundleURL
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([TypePowerModel].self, from: data)
    }
}

struct TypePowerProvider: TypePowerInteractor {
    var bundleURL: URL {
        Bundle.main.url(forResource: "typePower", withExtension: "json")!
    }
    
    var docURL: URL {
        URL.documentsDirectory.appending(path: "typePower.json")
    }
    
}

