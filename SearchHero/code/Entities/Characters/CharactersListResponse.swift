//
//  CharactersListResponse.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import Foundation
import SwiftUI

// MARK: - CharactersListResponse
struct CharactersListResponse: Codable, Identifiable {
    var id: Int
    var name, resultDescription: String
    var modified: String?
    var thumbnail: Thumbnail?
    var resourceURI: String?
    var comics, series: Comics?
    var stories: Stories?
    var events: Comics?
    var urls: [URLElement]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
    
    var getModifiedString: String {
        return Utils.changeDateString(modified ?? "") ?? (modified ?? "")
    }
}

// MARK: - Comics
struct Comics: Codable {
    var available: Int?
    var collectionURI: String?
    var items: [ComicsItem]
    var returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    var resourceURI: String?
    var name: String?
}

// MARK: - Stories
struct Stories: Codable {
    var available: Int?
    var collectionURI: String?
    var items: [StoriesItem]
    var returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    var resourceURI: String?
    var name: String?
    var type: String?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    var path: String
    var thumbnailExtension: String
    
    var getTThumbnailUrl:String {
        return path + "." + thumbnailExtension
    }

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}


// MARK: - URLElement
struct URLElement: Codable, Identifiable {
    var id: UUID?
    var type: String
    var url: String?
}
