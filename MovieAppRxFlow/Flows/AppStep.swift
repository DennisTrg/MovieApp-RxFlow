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
    
    
    case movieListScreen
    case searchMovieScreen
    
    case pickedMovie(id: Int)
}
