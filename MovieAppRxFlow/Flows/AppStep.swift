//
//  AppStep.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import RxFlow

enum AppStep: Step{
    case dashboard
    
    // Navigate to tab bar with 2 screens
    case movieListScreen
    case searchMovieScreen
    
    //Navigate to Movie Detail Screen
    case pickedMovie(withModel: MovieInfo)
}
