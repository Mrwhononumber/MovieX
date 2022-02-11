//
//  Constants.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import Foundation

struct Constants {
    
    static let APIKey = "8017dc1981a44aa2e9e6c0a8ebf9e51c"
    static let trendingMoviesURL = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey)"
    static let trendingTvURL = "https://api.themoviedb.org/3/trending/tv/day?api_key=\(APIKey)"
    static let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(APIKey)&language=en-US&page=1"
    static let upcomingMoviesURL = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(APIKey)&language=en-US&page=1"
    static let topRatedMoviesURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKey)&language=en-US&page=1"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    
    
    
}