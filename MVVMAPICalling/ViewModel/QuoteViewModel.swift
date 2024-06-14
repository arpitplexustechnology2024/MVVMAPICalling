//
//  QuoteViewModel.swift
//  MVVMAPICalling
//
//  Created by Arpit iOS Dev. on 14/06/24.
//

import Foundation
import Alamofire

class QuoteViewModel {
    
    func fetchRandomMovieQuotes(count: String, completion: @escaping (Result<Welcome, Error>) -> Void) {
        let url = "https://andruxnet-random-famous-quotes.p.rapidapi.com/"
        let headers: HTTPHeaders = [
            "X-RapidAPI-Key": "e103305047msh67c54e4389f5e37p106668jsn6f55a35f4271",
        ]
        
        let parameters: [String: String] = [
            "cat": "movies",
            "count": count
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: [WelcomeElement].self) { response in
                switch response.result {
                case .success(let quotes):
                    DispatchQueue.main.async {
                        completion(.success(quotes))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
    }
}
