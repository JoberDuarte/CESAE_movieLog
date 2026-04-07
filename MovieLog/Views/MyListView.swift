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
                                AsyncPosterView(path: movie.posterPath)
                                    .frame(height: 160)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .clipped()
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image("Image")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)

                    Text("Minha Lista")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
