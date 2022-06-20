//
//  ContentView.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import SwiftUI

struct MovieListView: View {
    @State var searchText = ""
    @State var page = 1
    @ObservedObject var viewModel = MovieListViewModel()
    
    var body: some View {
        VStack {
             ZStack {
                 Rectangle()
                     .foregroundColor(.gray)
                     .cornerRadius(10)
                 HStack {
                     Image(systemName: "magnifyingglass")
                         .padding(8)
                     TextField("Search For Movies...", text: $searchText)
                         .font(Font.system(size: 24))
                 }
                 .background(.white)
                 .cornerRadius(6)
                 .padding(4)
             }
             .frame(height: 24)
             .padding([.top],24)
             
             ScrollView {
                 ForEach(viewModel.movieList) { movie in
                     MovieListCell(viewModel: MovieDetailViewModel(movie: movie))
                 }
             }
             .padding([.leading, .trailing], 24)
            
             Spacer()
             Button {
                 viewModel.fetchMovies(searchTerm: searchText, page: page)
             } label: {
                 Text("Search")
             }
             .frame(width: 200, height: 50)
             .background(Color.blue)
             .foregroundColor(Color.white)
             .font(Font.system(size: 24))
             .cornerRadius(8)

         }
    }
}

///This Struct is responsible for setting up a movie detail cell
///
/// - Parameters:
/// - viewModel: The view model to be passed in with a movie. Also calls the the fetchImage function. The Image is populated asynchronously by the view model as Data() and logic is done with coelescing operators in the SwiftUI view reactively.

struct MovieListCell: View {
   @ObservedObject var viewModel: MovieDetailViewModel
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: ((UIImage(data: viewModel.image ?? Data()) ?? UIImage(systemName: "exclamationmark.icloud.fill"))!))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 60)
                VStack(alignment: .leading) {
                    Text(viewModel.movie.name)
                    Text("Released: " + (viewModel.movie.releaseDate ?? ""))
                    Spacer()
                }
                
                Spacer()
            }
            if let description = viewModel.movie.description {
                Text(description)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding([.top, .bottom], 8)
        .onAppear {
            viewModel.fetchImage()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
