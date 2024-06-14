//
//  GithubViewModel.swift
//  MVVMAPICalling
//
//  Created by Arpit iOS Dev. on 14/06/24.
//

import Foundation
import Alamofire

class GithubViewModel {
    
    func fetchRandomGithubData(query: String, completion: @escaping (Result<GithubData, Error>) -> Void) {
        
        let url = "https://api.github.com/search/users"
        let parameters: [String: Any] = [
            "q": query
        ]
        
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: GithubData.self) { response in
                switch response.result {
                    
                case .success(let GithubData):
                    DispatchQueue.main.async {
                        completion(.success(GithubData))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
    }
}
