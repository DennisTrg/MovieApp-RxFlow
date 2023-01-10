//
//  searchMovieScreenFlow.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import RxFlow
import RxSwift
import RxRelay

class SearchMovieFlow: Flow{
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
        case .searchMovieScreen:
            return navigateToSearchScreen()
        default:
            return .none
        }
    }
    
    func navigateToSearchScreen() -> FlowContributors{
        let vc = SearchVC()
        let viewModel = SearchViewModel(withService: self.services)
        vc.viewModel = viewModel
        vc.title = "Search"
        self.rootViewController.pushViewController(vc, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: vc.viewModel))
    }
}
