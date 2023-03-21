//
//  YoutubeMedia.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 21.03.2023.
//

import Foundation

struct YoutubeResult: Decodable{
    let items: [YoutubeItem]
}

struct YoutubeItem: Decodable{
    let id: YoutubeMedia
}

struct YoutubeMedia: Decodable{
    let videoId: String
    let kind: String
}
