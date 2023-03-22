//
//  APIManager.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 16.03.2023.
//

import Foundation
import Alamofire

enum APIError: Error{
    case failedToFetch
}

enum MediaType: Int{
    case Movie
    case Tv
    case TopRated
    case Upcoming
}


class APIManager{
    static let shared = APIManager()
    
    func fetchTmdbMedia(mediaType:MediaType,completion: @escaping (Result<[TmdbMedia], Error>) -> Void){
        
        let mediaType :String = {
            switch mediaType{
            case MediaType.Movie:
                return "trending/movie/day"
            case MediaType.Tv:
                return "trending/tv/day"
            case MediaType.TopRated:
                return "movie/top_rated"
            case MediaType.Upcoming:
                return "movie/upcoming"
            }
        }()
        
        let urlString = "\(Constants.tmdbBaseUrl)\(mediaType)?api_key=\(Constants.tmdbApiKey)"
        
        
        AF.request(urlString).validate().responseDecodable(of: TmdbResult.self) { (response) in
            guard let result = response.value else{
                
                completion(.failure(APIError.failedToFetch))
                return
            }
            
            completion(.success(result.results))
        }
        
    }
    
    func fillSearchVCTrends(completion: @escaping (Result<[TmdbMedia], Error>) -> Void){
        let urlString = "\(Constants.tmdbBaseUrl)discover/movie?&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate&api_key=\(Constants.tmdbApiKey)"
       
        AF.request(urlString).validate().responseDecodable(of: TmdbResult.self) { (response) in
            guard let result = response.value else{
                
                completion(.failure(APIError.failedToFetch))
                return
            }
            
            completion(.success(result.results))
        }
        
    }
    
    func searchForTmdb(_ query: String, completion: @escaping (Result<[TmdbMedia], Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        let urlString = "\(Constants.tmdbBaseUrl)search/movie?api_key=\(Constants.tmdbApiKey)&query=\(query)"
       
        AF.request(urlString).validate().responseDecodable(of: TmdbResult.self) { (response) in
            guard let result = response.value else{
                completion(.failure(APIError.failedToFetch))
                return
            }
            
            completion(.success(result.results))
        }
        
    }
    
    func searchForYoutube(_ query: String, completion: @escaping(Result<YoutubeItem, Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        let urlString = "\(Constants.youtubeBaseUrl)search?q=\(query)&key=\(Constants.youtubeApiKey)"
        
        AF.request(urlString).validate().responseDecodable(of: YoutubeResult.self) { response in
            guard let result = response.value else {
                completion(.failure(APIError.failedToFetch))
                return
            }
            
            completion(.success(result.items[0]))
        }
    }

}
