//
//  ListMoviesScreenFlow.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import RxFlow
import RxSwift
import RxRelay

class ListMoviesFlow: Flow{
    
    var root: Presentable{
        return self.rootViewController
    }
    private let rootViewController = UINavigationController()
    private let services: AppServices
    
    init(withServices services: AppServices){
        self.services = services
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .movieListScreen:
            return navigateToListMovieScreen()
        case .pickedMovie(let model):
            return navigateToDetailMovieScreen(movieInfo: model)
        default:
            return .none
        }
    }
    
    private func navigateToListMovieScreen() -> FlowContributors{
        let vc = HomeVC()
        let viewModel = HomeViewModel(withService: self.services)
        vc.viewModel = viewModel
        vc.title = "Home"
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: vc.viewModel))
    }
    
    private func navigateToDetailMovieScreen(movieInfo: MovieInfo) -> FlowContributors{
        let vc = MovieDetailVC()
        let viewModel = MovieDetailViewModel(withModel: movieInfo)
        vc.viewModel = viewModel
        vc.title = movieInfo.title
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: vc.viewModel))
    }
}
