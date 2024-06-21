//
//  BasesPagerModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import Foundation

struct BasesPagerModel<T: Codable>: Codable  {
    var offset, limit, total, count: Int
    var results: [T]
}
