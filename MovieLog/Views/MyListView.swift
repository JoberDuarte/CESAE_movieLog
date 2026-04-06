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
            Group {
                if moviesVM.movies.isEmpty {
                    ContentUnavailableView(
                        "A tua lista está vazia",
                        systemImage: "film.stack",
                        description: Text("Adiciona filmes/séries na Home ou Pesquisa.")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(moviesVM.movies) { movie in
                                NavigationLink {
                                    MovieDetailFromMediaView(item: movie.asMediaItem)
                                } label: {
                                    PosterCardView(path: movie.posterPath)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle("Minha Lista")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { moviesVM.loadMovies() }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                }
            }
        }
    }
}
