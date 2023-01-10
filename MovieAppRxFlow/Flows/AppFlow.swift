//
//  AppFlow.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
class AppFlow: Flow{
    
    var root: Presentable{
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let vc = UINavigationController()
        vc.setNavigationBarHidden(true, animated: false)

        return vc
    }()
    
    private let services: AppServices
    
    init(withServices services: AppServices){
        self.services = services
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .dashboard:
            //return navigateToDashBoard()
            return navigateToDashboardFlow()
        default:
            return .none
        }
    }
    
    private func navigateToDashboardFlow() -> FlowContributors{
        let dashboardFlow = DashboardFlow(withServices: self.services)
        
        Flows.use(dashboardFlow, when: .created) {[unowned self] (root) in
            self.rootViewController.pushViewController(root, animated: false)
        }

        return .one(flowContributor: .contribute(withNextPresentable: dashboardFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AppStep.dashboard)))
    }
}

class AppStepper: Stepper{
    var steps = PublishRelay<Step>()
    private let services: AppServices
    
    var initialStep: Step{
        return AppStep.dashboard
    }
    
    init(withServices services: AppServices){
        self.services = services
    }
    
}


