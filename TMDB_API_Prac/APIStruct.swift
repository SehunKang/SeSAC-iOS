//
//  APIStruct.swift
//  TMDB_API_Prac
//
//  Created by Sehun Kang on 2021/12/26.
//

import Foundation

// MARK: - TVshow
struct TVshow: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let backdropPath: String?
    let firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct TvShowDetail: Codable {
    let name: String
    let numberOfSeasons: Int
    let seasons: [Season]
    
    enum CodingKeys: String, CodingKey {
        case name
        case numberOfSeasons = "number_of_seasons"
        case seasons
    }
}

struct Season: Codable {
    let airDate: String?
    let episodeCount, id, seasonNumber: Int
    let name, overview, posterPath: String

    
    enum CodingKeys: String, CodingKey {
        case airDate =  "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

