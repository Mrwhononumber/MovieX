//
//  MoviexError.swift
//  MovieX
//
//  Created by Basem El kady on 2/11/22.
//

import Foundation

enum MoviexError: String, Error {
    
    case invalidURL           = "The URL you're using is invalid"
    case unableToComplete     = "Unable to complete your request, please check your internet connection"
    case invalidResponse      = "Invalid response from the server, please try again"
    case invalidData          = "The data received from the server is invalid, please try again"
    case dataSavingFailure    = "something went wrong while saving your data to the, please try again"
    case dataLoadingFailure   = "something went wrong while loading your saved data, please try again"
    case dataDeletionFailure  = " something went wrong while deliting your data, please try again"
}
