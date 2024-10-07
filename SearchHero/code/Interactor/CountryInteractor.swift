//
//  CountryInteractor.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 4/7/24.
//

import Foundation

protocol CountryInteractor {
    var bundleURL:URL { get }
    var docURL:URL { get }
    func loadCountryData() throws -> [CountryData]
}

extension CountryInteractor {
    func loadCountryData() throws -> [CountryData] {
        var url = docURL
        if !FileManager.default.fileExists(atPath: url.path()) {
            url = bundleURL
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([CountryData].self, from: data)
    }
}

struct CountryProvider: CountryInteractor {
    var bundleURL: URL {
        Bundle.main.url(forResource: "countries", withExtension: "json")!
    }
    
    var docURL: URL {
        URL.documentsDirectory.appending(path: "countries.json")
    }
    
}

