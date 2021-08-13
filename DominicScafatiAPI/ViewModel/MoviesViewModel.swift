//
//  MoviesViewModel.swift
//  DominicScafatiAPI
//
//  Created by Dom Scafati on 8/13/21.
//

import Foundation

protocol MoviesViewModelProtocal {
    func searchMovies(searchText:String?)
    func getMovie(for index:Int)-> (title:String, year:String, posterUrl:String)
}

class MoviesViewModel<T:Servicable>: MoviesViewModelProtocal {
    
    private var service:T!
    weak private var delegate:MoviesViewControllerProttocol!
    
    private var movieResult:MovieResult? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.refreshUI()
            }
        }
    }

    var numberofMovies:Int {
        get {
            return movieResult?.movies.count ?? 0
        }
    }
    
    // Injecting Dependencies of delegate and service class
    init(delegate:MoviesViewControllerProttocol, service:T) {
        self.service = service
        self.delegate = delegate
    }
    
     /*
         this method called from outside to connect to server to get movie result
         Only integrated page = 1 currently
     */
    func searchMovies(searchText:String?) {
        guard let _searchText = searchText , _searchText.count > 0 else {
            return
        }
        service.searchMovies(baseUrl:EndPoints.baseUrl.rawValue ,path: "",params:"apikey=\(apiKey)&s=\(_searchText)&page=1") { [weak self] (result )  in
            switch result {
            case .success(let model):
                self?.movieResult = model as? MovieResult
            case .failure(let error):
                self?.movieResult = nil
                self?.delegate?.showError(message:error.localizedDescription)
            }
        }
    }
    
    /*
        this method will take index as input and return movie title, year and poster url as tupple if movie exists for that index otherwise will return empty values.
    */
    func getMovie(for index:Int)-> (title:String, year:String, posterUrl:String) {
        guard let movies = movieResult?.movies else {
            return ("", "", "")
        }
        if movies.count > index {
            let movie = movies[index]
            return (movie.title, movie.year, movie.poster)
        }
        return ("", "", "")
    }
 
}
