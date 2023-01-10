//
//  MoviesModel.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation

struct MoviesModel: Codable{
    let page: Int?
    let results: [ListMoviesResult]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
