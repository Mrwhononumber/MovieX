//
//  APICaller.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import Foundation

class APICaller {
   
    static let shared = APICaller()
    
    func getTrendingMovies (completion: @ escaping (Result<[Movie], MoviexError>) -> Void) {
        
        guard let url = URL(string: Constants.trendingURL+Constants.APIKey) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }

                return

            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            do {
                let resultArray = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(resultArray.results))
            
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
               return
            }
            
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
}
