//
//  MyListView.swift
//  MovieLog
//
//  Created by iMac11 on 06/04/2026.
//
import SwiftUI

struct MyListView: View {
    @EnvironmentObject var moviesVM: MoviesViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack {
            if moviesVM.movies.isEmpty {
                ContentUnavailableView(
                    "A tua lista está vazia",
                    systemImage: "film.stack",
                    description: Text("Adiciona filmes/séries para aparecerem aqui.")
                )
                .navigationTitle("Minha Lista")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(moviesVM.movies) { movie in
                            NavigationLink {
                                MovieDetailView(movie: movie)
                            } label: {
                                AsyncPosterView(path: movie.posterPath)
                                    .frame(height: 170)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                .navigationTitle("Minha Lista")
            }
        }
    }
}
