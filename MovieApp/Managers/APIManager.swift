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
    
    func getMedia(mediaType:MediaType,completion: @escaping (Result<[Media], Error>) -> Void){
        
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
        
        let urlString = "\(Constants.baseUrl)\(mediaType)?api_key=\(Constants.apiKey)"
        
        
        AF.request(urlString).validate().responseDecodable(of: API_Results.self) { (response) in
            guard let result = response.value else{
                print(response.debugDescription)
                completion(.failure(APIError.failedToFetch))
                return
            }
            
            completion(.success(result.results))
        }
        
    }
    
    func searchMedia(completion: @escaping (Result<[Media], Error>) -> Void){
        let urlString = "\(Constants.baseUrl)discover/movie?&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate&api_key=\(Constants.apiKey)"
       
        AF.request(urlString).validate().responseDecodable(of: API_Results.self) { (response) in
            guard let result = response.value else{
                print(response.debugDescription)
                completion(.failure(APIError.failedToFetch))
                return
            }
            
            completion(.success(result.results))
        }
        
    }

}
