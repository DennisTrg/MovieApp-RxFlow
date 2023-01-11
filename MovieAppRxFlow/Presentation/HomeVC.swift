//
//  HomeVC.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    let customRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        return refreshControl
    }()
    
    let collectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
         
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        return collectionView
    }()
    
    deinit {
        print("Deinit - Home VC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Leak Home Vc")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupData()
        viewModel.movieService?.fetchMovie()
    }
    
    //MARK: Set up View
    private func setupView(){
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()        }
        collectionView.rx.setDelegate(self)
        collectionView.refreshControl = customRefreshControl
    }
    
    //MARK: Pass Data
    private func setupData(){
        viewModel.movieService?.movie().observe(on: MainScheduler.instance).bind(to: collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) {
            (row, element, cell) in
            cell.config(model: element, index: row)
        }.disposed(by: disposeBag)

        customRefreshControl.rx.controlEvent(.valueChanged).asDriver().drive(onNext:{[weak self] in
            self?.viewModel.movieService?.fetchMovie()
            self?.collectionView.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(MovieInfo.self).asDriver().drive(onNext:{[weak self] (model) in
            self?.viewModel.pick(movieInfo: model)
        }).disposed(by: disposeBag)
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.41, height: view.frame.size.height * 0.34)
    }
}

