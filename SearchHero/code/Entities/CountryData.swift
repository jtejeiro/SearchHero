//
//  CountryData.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 4/7/24.
//

import Foundation

struct CountryData: Codable,Identifiable{
    let id: Int
    let alpha2, alpha3, name: String
}
