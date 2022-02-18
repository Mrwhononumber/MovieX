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
    
    private var cache = NSCache <NSString, UIImage>()
    
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
    
    func fetchTitleImage(url: String, completion: @escaping (Result<UIImage, MoviexError>) -> Void ){
        
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(.success(cachedImage))
            return
        }
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
            guard let titleImage = UIImage(data: ImageData) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return }
            self.cache.setObject(titleImage, forKey: url as NSString)
            DispatchQueue.main.async {
                completion(.success(titleImage))
            }
        }
        task.resume()
    }

    
    func searchWith(query:String, url: String, completion: @ escaping (Result<[Title], MoviexError>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url   = URL(string: url+query) else {
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
    
    func getYoutubeTrailerIdWith(query:String, url: String, completion: @ escaping (Result<String, MoviexError>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: url+query) else {
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
                let videoElement = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                let videoID = videoElement.items[0].id.videoId
                completion(.success(videoID))
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
