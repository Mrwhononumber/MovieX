//
//  YoutubeSearchResponse.swift
//  MovieX
//
//  Created by Basem El kady on 2/13/22.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    
    let items: [Items]
}

struct Items: Codable {
    
    let id: YoutubeVideoObject
}

struct YoutubeVideoObject: Codable {
    
    let videoId: String 
}
