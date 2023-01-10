//
//  ApiService.swift
//  MovieAppRxFlow
//
//  Created by Tung Truong on 10/01/2023.
//

import Foundation
import RxSwift

protocol ApiServiceProtocol{
    func fetchRequest(url: String) -> Observable<MoviesModel>
}

class ApiService{
    static func ImageUrlString(imagePath: String) -> String{
        return "https://image.tmdb.org/t/p/original/\(imagePath)"
    }
    
    static func urlString(category: String, page: Int) -> String{
        return "https://api.themoviedb.org/3/movie/\(category)?api_key=\(APIKey)&page=\(page)"
    }
    
    static func urlString(keyword: String, page: Int) -> String {
        return "https://api.themoviedb.org/3/search/movie?query=\(keyword)&api_key=\(APIKey)&page=\(page)"
    }
    static func urlString(id: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)?api_key=\(APIKey)"
    }
}

extension ApiService: ApiServiceProtocol{
    func fetchRequest(url: String) -> Observable<MoviesModel>{
        return Observable.create { observer -> Disposable in
            //retrieve data from URL
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                if let error = error {
                    observer.onError(error)
                }
                guard let data = data else {
                    let response = response as? HTTPURLResponse
                    observer.onError(NSError(domain: "No Data", code: response?.statusCode ?? -1, userInfo: nil))
                    return
                }
            
                do {
                    //decode data
                    let movieList = try JSONDecoder().decode(MoviesModel.self, from: data)
                    observer.onNext(movieList)
                } catch{
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
                print("DISPOSE")
            }
        }
    }
}
