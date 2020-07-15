//
//  RestAPI.swift
//  salinas-test
//
//  Created by Macintosh HD on 14/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import Alamofire

fileprivate let baseURL = "https://api.tvmaze.com"

class RestAPI {
    
    class func getShows(completion: @escaping (Result<[Show], Error>) -> Void) {
        
        let uri = baseURL + "/shows"
        
        AF.request(uri.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, method: .get)
            .responseDecodable { (response: DataResponse<[Show], AFError>) in
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let mappedResponse = try jsonDecoder.decode([Show].self, from: response.data!)
                    completion(.success(mappedResponse))
                } catch (let error) {
                    completion(.failure(error))
                }

        }
        
    }
       
    
}
