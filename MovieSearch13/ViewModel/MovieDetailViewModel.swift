//
//  MovieDetailViewModel.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    
    var movie: Movie
    let apiClient = APIClient()
    
    @Published var image: Data?
    
    var movieImageSubscriber: AnyCancellable?

    init(movie: Movie) {
        self.movie = movie
    }
    
    func fetchImage() {
        apiClient.fetchImage(for: movie)
        movieImageSubscriber = apiClient.movieImagePublisher?.sink(receiveCompletion: {
            print("================================================================")
            print("IMAGE DATA FOR MOVIE: \(self.movie.name) STATUS: \($0)")
        }, receiveValue: { imageData in
            self.image = imageData
        })
    }
}
