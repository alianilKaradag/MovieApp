//
//  APIManager.swift
//  MovieApp
//
//  Created by Anıl Karadağ on 16.03.2023.
//

import Foundation
import Alamofire

enum APIEror: Error{
    case fetchFail
}


class APIManager{
    static let shared = APIManager()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        let urlString = "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.apiKey)"
        AF.request(urlString).validate().responseDecodable(of: TrendingMovieResponse.self) { (response) in
            guard let result = response.value else{
                print(response.debugDescription)
                return
            }
            
            completion(.success(result.results))
        }
        
    }
}
