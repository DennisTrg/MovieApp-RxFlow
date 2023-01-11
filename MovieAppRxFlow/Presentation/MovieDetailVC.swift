//
//  MovieDetailVC.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 11/01/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
class MovieDetailVC: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: MovieDetailViewModel!
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "img_placeholder")
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 5
        return stack
    }()
    
    lazy var movieNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    lazy var overViewLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lb.numberOfLines = 0
        return lb
    }()
    
    deinit {
        print("Deinit - Movie Detail VC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Leak Movie Detail VC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    //MARK: Set up View
    private func setupView(){
        self.view.clipsToBounds = true
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(movieImageView)
        movieImageView.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.frame.size.height / 3)
        }
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(movieImageView.snp.bottom)
        }
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(overViewLabel)
    }
    
    //MARK: Set up Data
    private func setupData(){
        self.viewModel.setupImage(model: self.viewModel.model) {[weak self] (image) in
            DispatchQueue.main.async {
                self?.movieImageView.image = image
                self?.movieNameLabel.text = self?.viewModel.movieName
                self?.overViewLabel.text = self?.viewModel.movieOverview
            }
        }
    }
}
