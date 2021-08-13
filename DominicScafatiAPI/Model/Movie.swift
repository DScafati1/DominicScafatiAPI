//
//  Movie.swift
//  DominicScafatiAPI
//
//  Created by Dom Scafati on 8/13/21.
//

import Foundation

struct MovieResult: Codable {
    let movies:[Movie]
    let totalResult:String
    
    enum CodingKeys: String, CodingKey {
       case movies = "Search"
       case totalResult = "totalResults"
    }
}

struct Movie: Codable {
    let title:String
    let year:String
    let type:String
    let poster:String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
