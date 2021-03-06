//
//  APIClient.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import Foundation
import Combine


class APIClient: ObservableObject {
    
    static let apiKey = "6e6b1cb140fbaee2fe4a98f1ec253860"
    
    var movieListPublisher: AnyPublisher<MovieResponse, Error>?
    var movieImagePublisher: AnyPublisher<Data,Error>?
    
    static var urlString = "https://api.themoviedb.org/3/search/movie"
    
    func fetchMovies(searchTerm: String, page: Int = 1, allowMatureResults explicit: Bool = false) {
        guard !searchTerm.isEmpty else { return }
        guard let url = URL(string: APIClient.urlString ) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "api_key", value: APIClient.apiKey),
                                 URLQueryItem(name: "query", value: searchTerm),
                                 URLQueryItem(name: "include_adult", value: "\(explicit)")]
        guard let finishedURL = components?.url else { return }
        movieListPublisher = URLSession.shared.dataTaskPublisher(for: finishedURL)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
                return element.data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            
    }
    
    func fetchImage(for movie: Movie) {
        guard var urlString = URL(string: "https://image.tmdb.org/t/p/w500/") else { return }
        if let thumbnail = movie.thumbnail {
            urlString.appendPathComponent(thumbnail)
            movieImagePublisher = URLSession.shared.dataTaskPublisher(for: urlString)
                .tryMap() { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
    
}
