//
//  MovieListViewModel.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    
    
    private var textUpdateSubscriber: AnyCancellable?
    private var movieListUpdateSubscriber: AnyCancellable?
    
    @Published var movieList: [Movie] = []
    @Published var currentText: String

    let apiClient = APIClient()
    
    
    init(initialSearchString: String, delay: Double = 0.75) {
        _currentText = Published(initialValue: initialSearchString)
        
        textUpdateSubscriber =  $currentText
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { value in
                print(value)
                self.fetchMovies(searchText: value, page: 1)
            }

    }
    

    func fetchMovies(searchText: String, page: Int?) {
        apiClient.fetchMovies(searchTerm: searchText)
        
        movieListUpdateSubscriber = apiClient.movieListPublisher?
            .sink(receiveCompletion: {
            print ("Received completion: \($0).")
        }, receiveValue: { movieResponse in
            self.movieList = movieResponse.results
        })
    }
}
