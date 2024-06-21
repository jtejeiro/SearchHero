//
//  BasesMarvelResponse.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//


import Foundation

struct BasesMarvelResponse<T: Codable>:Codable {
    var code: Int?
    var status: String?
    var data:BasesPagerModel<T>
}
