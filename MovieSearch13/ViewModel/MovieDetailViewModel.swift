//
//  MovieDetailViewModel.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import SwiftUI
import Combine

class MovieDetailViewModel: ObservableObject {
    
    var movie: Movie
    let apiClient = APIClient()
    
    @Published var image = Image(systemName: "exclamationmark.icloud.fill")
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
            self.image = self.convertImageData(imageData)
        })
    }
    
    private func convertImageData(_ data: Data) -> Image {
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "exclamationmark.icloud.fill")
        }
    }
    
}


extension String {
    func parseDateString() -> String {
        let dateComponents = self.split(separator: "-")
        if (dateComponents.count < 3) != true {
            let year = dateComponents[0]
            let monthInt = Int(dateComponents[1]) ?? 0
            var month = ""
            let day = dateComponents[2]
            
                switch monthInt {
                case 1: month = "Jan"
                case 2: month = "Feb"
                case 3: month = "March"
                case 4: month = "April"
                case 5: month = "May"
                case 6: month = "June"
                case 7: month = "July"
                case 8: month = "Aug"
                case 9: month = "Sep"
                case 10: month = "Oct"
                case 11: month = "Nov"
                case 12: month = "Dec"
                default: month = ""
                }
            
            
            return "\(month) \(day), \(year)"
        } else {
            return ""
        }
       
    }
}
