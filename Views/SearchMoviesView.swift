//
//  SearchMoviesView.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import SwiftUI

struct SearchMoviesView: View {
    @EnvironmentObject var moviesVM: MoviesViewModel
    @StateObject private var vm = SearchMoviesViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    TextField("Pesquisar...", text: $vm.query)
                        .textFieldStyle(.roundedBorder)

                    Button("Buscar") {
                        Task { await vm.search() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(vm.results, id: \.id) { item in
                            Button {
                                let newMovie = Movie(
                                    title: item.title,
                                    overview: item.overview,
                                    posterPath: item.posterPath,
                                    tmdbID: item.tmdbID,
                                    status: .toWatch,
                                    personalRating: item.voteAverage ?? 0,
                                    isWatched: false
                                )
                                moviesVM.addMovie(newMovie)
                            } label: {
                                PosterCardView(path: item.posterPath)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("Pesquisar")
        }
    }
}
