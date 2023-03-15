//
//  Movie.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 16.03.2023.
//

import Foundation

struct Movie: Decodable{
    let id: Int
    let title: String?
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
}

struct TrendingMovieResponse: Decodable{
    let results: [Movie]
}
