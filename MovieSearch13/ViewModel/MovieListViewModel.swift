//
//  MovieListViewModel.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    
    @Published var movieList: [Movie] = []
    
    let apiClient = APIClient()
    
    var movieListPopulationSubscriber: AnyCancellable?
    
    
    func fetchMovies(searchTerm: String, page: Int?) {
  
        apiClient.fetchMovies(searchTerm: searchTerm)
        
        
        movieListPopulationSubscriber = apiClient.movieListPublisher?.sink(receiveCompletion: {
            print ("Received completion: \($0).")
        }, receiveValue: { movieResponse in
            self.movieList = movieResponse.results
        })
    }
}
