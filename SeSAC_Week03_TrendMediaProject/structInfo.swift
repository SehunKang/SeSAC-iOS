//
//  Tvshow.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/15.
//

import Foundation

struct APIforTMDB {
	static let endpoint = "https://api.themoviedb.org/3"
	static let trending = "/trending/tv/week"
	static let credits = "/tv/id/credits"
	static let genre = "/genre/tv/list"
}

struct APIkey {
	static let TMDBkey = "7ef0e0c306672ea2fa568ed12416bc82"
}

struct Genre {
	static let genreDictionary: [Int:String] = [
		28:"액션",
		12:"모험",
		16:"애니메이션",
		35:"코메디",
		80:"범죄",
		99:"다큐멘터리",
		18:"드라마",
		10751:"가족",
		14:"판타지",
		36:"역사",
		27:"공포",
		10402:"음악",
		9648:"미스터리",
		10749:"로맨스",
		878:"SF",
		10770:"TV 영화",
		53:"스릴러",
		10752:"전쟁",
		37:"서부",
		10759:"Action & Adventure",
		10762:"Kids",
		10763:"News",
		10764:"Reality",
		10765:"Sci-Fi & Fantasy",
		10766:"Soap",
		10767:"Talk",
		10768:"War & Politics"
	]
}

struct TvInfo {
	var title: String
	var releaseDate: String
	var genre: [Int]
	var id: Int
	var rate: Double
	var posterImageUrl: String
	var overview: String
	var backdropImageUrl: String
}

struct DetailedTvInfo {
	var character: [String]
	var actor: [String]
	var actorImageURL:[String]
	var overview: String
	var backdropImageUrl: String
	
}

struct TvShow {
	var title: String
	var releaseDate: String
	var genre: String
	var region: String
	var overview: String
	var rate: Double
	var starring: String
	var backdropImage: String
}

struct TheaterLocation {
	var type: String
	var location: String
	var latitude: Double
	var longitude: Double
}

