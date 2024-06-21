//
//  ComicsListResponse.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 14/6/24.
//


import Foundation

// MARK: - Result
struct ComicsListResponse: Codable {
    let id, digitalID: Int
    let title: String
    let textObjects: [TextObject]?
    let resourceURI: String
    let urls: [URLElement]?
    let series: Series?
    let prices: [Price]?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?
    let creators: Creators?
    let characters: Characters?
    let stories: Stories?
    let events: Characters?

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, textObjects, resourceURI, urls, series, prices, thumbnail, images, creators, characters, stories, events
    }
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Series]
    let returned: Int
}

// MARK: - Series
struct Series: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int
    let collectionURI: String
    let items: [CreatorsItem]
    let returned: Int
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String
    let name, role: String
}

// MARK: - Price
struct Price: Codable {
    let type: String
    let price: Double
}


// MARK: - TextObject
struct TextObject: Codable {
    let type, language, text: String
}

