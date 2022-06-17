//
//  MovieSearch13App.swift
//  MovieSearch13
//
//  Created by Colin Smith on 6/16/22.
//

import SwiftUI

@main
struct MovieSearch13App: App {
    var body: some Scene {
        WindowGroup {
                MovieListView()
                    .navigationBarTitleDisplayMode(.inline)
        }
    }
}
