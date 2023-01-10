//
//  MovieService.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import RxRelay
import RxSwift

protocol HasMovieService{
    var movieService: MovieService? { get }
}

final class MovieServiceViewModel {
    private let apiService: ApiServiceProtocol
    var listMovie = BehaviorRelay<[MovieInfo]>(value: [])
    var listSearchResult = BehaviorRelay<[MovieInfo]>(value: [])
    init(apiService: ApiServiceProtocol = ApiService()){
        self.apiService = apiService
    }
    
    func fetchMovieResult(url: String){
        apiService.fetchRequest(url: url).map { movieList -> [ListMoviesResult] in
            guard let movieListResult = movieList.results else {return []}
            return movieListResult
        }.map { movieResult in
            movieResult.map {MovieInfo.convertMovieToFormat(movieInfo: $0)}
       }.take(1)
           .bind(to: listMovie)
    }
    
    func fetchMovieSearchResult(keyword: String, page: Int){
        if keyword.count == 0{
            return
        }
        
        let url = ApiService.urlString(keyword: keyword, page: page)
        apiService.fetchRequest(url: url).map { movieList -> [ListMoviesResult] in
            guard let movieListResult = movieList.results else {return []}
            return movieListResult
        }.map { movieResult in
            movieResult.map {MovieInfo.convertMovieToFormat(movieInfo: $0)}
       }.take(1)
            .bind(to:listSearchResult)
    }
}

class MovieService {
    
    private let viewModel = MovieServiceViewModel()
    
    func fetchMovie(){
        viewModel.fetchMovieResult(url: ApiService.urlString(category: "popular", page: 1))
    }
    
    func movie() -> BehaviorRelay<[MovieInfo]>{
        return viewModel.listMovie
    }
    
    func searchMovie(keyword: String, page: Int){
        viewModel.fetchMovieSearchResult(keyword: keyword, page: page)
    }
    
    func searchMovieResult() -> BehaviorRelay<[MovieInfo]>{
        return viewModel.listSearchResult
    }
    
}
