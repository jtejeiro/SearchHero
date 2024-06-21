//
//  ExtDictionary.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [String: Any]){
        for (k, v) in dict {
            updateValue(v as! Value, forKey: k as! Key)
        }
    }
}
