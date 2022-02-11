//
//  APICaller.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import Foundation
import UIKit

class APICaller {
   
    static let shared = APICaller()
    
    func fetchTitleData (with url: String, completion: @ escaping (Result<[Title], MoviexError>) -> Void) {
        
        guard let url = URL(string: url) else {
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
                let resultArray = try JSONDecoder().decode(MoviesModel.self, from: data)
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
    
    func fetchTitleImage(url: String, completion: @escaping (Result<(UIImage), MoviexError>) -> Void ){
        
        guard let ImageUrl = URL(string: url) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            
            return }
        let task = URLSession.shared.dataTask(with: ImageUrl) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
               
                return
            }
            
            guard let ImageData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                
                return }
            guard let pokemonImage = UIImage(data: ImageData) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
               
                return }
            
            DispatchQueue.main.async {
                completion(.success(pokemonImage))
            }
            
        }
        
        task.resume()
    }

    
    
    
    
    
    
    
    
    
    
    
}
