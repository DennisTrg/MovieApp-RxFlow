//
//  MovieInfo.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation

struct MovieInfo: Codable{
    let id: Int?
    let originalTitle: String?
    let posterPath: String?
    let genre: String?
    let releaseDate: String?
    let ratingScore: Double
    let backdropPath: String?
    let title: String?
    let overview: String?
}

extension MovieInfo{
    static func convertMovieToFormat(movieInfo: ListMoviesResult) -> MovieInfo{
        
        return MovieInfo(id: movieInfo.id ,originalTitle: movieInfo.originalTitle, posterPath: movieInfo.posterPath, genre: {() -> String in
            if let genreID = movieInfo.genreID{
                var genre: [String] = []
                genreID.map { id in
                    _ = genreCode.map({ (key,value) in
                        if key == id { genre.append(value)}
                    })}
                
                return genre.joined(separator: ", ")
            }
                return ""
        }(), releaseDate: movieInfo.releaseDate, ratingScore: movieInfo.voteAverage ?? 0, backdropPath: movieInfo.backdropPath, title: movieInfo.title, overview: movieInfo.overview)
    }
}
