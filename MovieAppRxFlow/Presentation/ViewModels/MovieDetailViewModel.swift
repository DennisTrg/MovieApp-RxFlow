//
//  MovieDetailViewModel.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 11/01/2023.
//

import Foundation
import RxFlow
import RxRelay
import RxSwift
class MovieDetailViewModel: Stepper{
    
    let model: MovieInfo
    var steps = PublishRelay<Step>()
    private (set) var backdropImage: UIImage?
    private (set) var movieName = ""
    private (set) var movieOverview = ""
    
    init(withModel model: MovieInfo){
        self.model = model
    }
    
    func setupImage(model: MovieInfo, completion: @escaping(UIImage) -> Void){
        movieName = model.originalTitle!
        movieOverview = model.overview!
        guard let imagePath = model.backdropPath else { return }
        guard let imageUrl = URL(string: ApiService.ImageUrlString(imagePath: imagePath)) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: imageUrl) { data, res, error in
            if let error = error {
                completion(UIImage(named: "img_placeholder")!)
            }
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        dataTask.resume()
    }
}
