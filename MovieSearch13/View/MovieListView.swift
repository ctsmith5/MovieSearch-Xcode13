//
//  ContentView.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import SwiftUI

struct MovieListView: View {
    @State var page = 1
    @StateObject var viewModel = MovieListViewModel(initialSearchString: "")
    var body: some View {
        VStack {
             ZStack {
                 Rectangle()
                     .foregroundColor(.gray)
                     .cornerRadius(10)
                 HStack {
                     Image(systemName: "magnifyingglass")
                         .padding(8)
                     TextField("Search For Movies...", text: $viewModel.currentText)
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
         }
    }
}

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
                        .bold()
                    Text("Released: " + (viewModel.movie.releaseDate?.parseDateString() ?? ""))
                        .font(.system(size: 12))
                    Spacer()
                }
                
                Spacer()
            }
            if let description = viewModel.movie.description {
                Text(description)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 12))
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
