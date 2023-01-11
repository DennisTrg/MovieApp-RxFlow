//
//  SearchTableViewCell.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import UIKit
import Cosmos
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_placeholder")
        return imageView
    }()
    
    let movieName: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        name.numberOfLines = 0
        name.minimumScaleFactor = 1

        return name
    }()
    
    let movieGenre: UILabel = {
        let genre = UILabel()
        genre.textAlignment = .left
        genre.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        return genre
    }()
    
    let releaseDate: UILabel = {
        let date = UILabel()
        date.textAlignment = .left
        date.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return date
    }()
    
    let movieRate: CosmosView = {
        let rate = CosmosView()
        rate.settings.totalStars = 5
        rate.settings.emptyBorderColor = .yellow
        rate.settings.filledColor = .yellow
        rate.settings.fillMode = .half
        rate.settings.starSize = 17
        rate.settings.starMargin = 1
        return rate
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    //MARK: Set up View
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(movieImageView)
        containerView.addSubview(stackView)
        movieImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(100)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
            make.left.equalTo(movieImageView.snp.right).offset(10)
        }
        stackView.addArrangedSubview(movieName)
        stackView.addArrangedSubview(movieGenre)
        stackView.addArrangedSubview(releaseDate)
        stackView.addArrangedSubview(movieRate)
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImageView.image = nil
        self.movieName.text = nil
        self.movieGenre.text = nil
        self.movieRate.rating = 0
        self.releaseDate.text = nil
    }
    
    //MARK: Set up Data
    func config(model: MovieInfo, index: Int){
        movieName.text = model.originalTitle
        movieGenre.text = model.genre
        releaseDate.text = model.releaseDate
        movieRate.rating = model.ratingScore / 2
        let itemNum = NSNumber(value: index)

        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let imagePath = model.posterPath else {return}
            guard let imageUrl = URL(string: ApiService.ImageUrlString(imagePath: imagePath)) else {return}
            do{
                let imageData = try Data(contentsOf: imageUrl)
                guard let image = UIImage(data: imageData) else {return}
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }catch{
                self?.movieImageView.image = UIImage(named: "img_placeholder")
            }
        }
    }
}
