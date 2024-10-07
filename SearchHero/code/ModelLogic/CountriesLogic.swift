//
//  CountriesLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 4/7/24.
//

import Foundation

@Observable
final class CountriesLogic {
    static let sharer = CountriesLogic()
    let interactor : CountryInteractor
    var countryData:[CountryData]
    
    
    init(_ interactor: CountryInteractor = CountryProvider()) {
        self.interactor = interactor
        do {
            self.countryData = try  interactor.loadCountryData()
        } catch {
            debugPrint(error)
            self.countryData = []
        }
    }
    
    func getCountriesList() async -> [ListFormString] {
        return countryData.map { item in
            ListFormString(id: item.id , name: item.name)
        }
    }
    
}
