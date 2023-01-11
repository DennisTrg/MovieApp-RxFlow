//
//  HomeViewModel.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import RxFlow
import RxRelay

class HomeViewModel: HasMovieService, Stepper{
    var movieService: MovieService?
    
    var steps = PublishRelay<Step>()
    
    init(withService services: AppServices){
        self.movieService = services.movieService
    }

    public func pick(movieInfo: MovieInfo){
        self.steps.accept(AppStep.pickedMovie(withModel: movieInfo))
    }
}
