//
//  DashboardFlow.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import RxFlow
import RxSwift

class DashboardFlow: Flow{
    
    var root: Presentable{
        return self.rootViewController
    }
    let rootViewController = UIViewController()
    private let services: AppServices
    
    init(withServices services: AppServices){
        self.services = services
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .dashboard:
            return navigateToDashBoard()
        default:
            return .none
        }
    }
    
    private func navigateToDashBoard() -> FlowContributors{
        let tabBarController = UITabBarController()
        let listMovieFlow = ListMoviesFlow(withServices: self.services)
        let searchMovieFlow = SearchMovieFlow(withServices: self.services)
        
        Flows.use(listMovieFlow, searchMovieFlow, when: .created) { [unowned self] (flow1Root: UINavigationController, flow2Root: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "Home",
                                           image: UIImage(systemName: "film.fill"),
                                           selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Search",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           selectedImage: nil)
            flow1Root.tabBarItem = tabBarItem1
            flow1Root.title = "Home"
            flow2Root.tabBarItem = tabBarItem2
            flow2Root.title = "Search"
            
            tabBarController.setViewControllers([flow1Root, flow2Root], animated: false)
            self.rootViewController.navigationController?.pushViewController(tabBarController, animated: true)
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: listMovieFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.movieListScreen)),.contribute(withNextPresentable: searchMovieFlow, withNextStepper: OneStepper(withSingleStep: AppStep.searchMovieScreen))])
    }
}


