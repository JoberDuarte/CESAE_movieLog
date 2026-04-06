//
//  MovieDetailView.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var moviesVM: MoviesViewModel
    @State private var showingEdit = false

    let movie: Movie

    var currentMovie: Movie {
        moviesVM.movies.first(where: { $0.id == movie.id }) ?? movie
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncPosterView(path: currentMovie.posterPath)
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(currentMovie.title)
                    .font(.title2.bold())

                HStack {
                    Label(currentMovie.status.rawValue, systemImage: "tag")
                    Spacer()
                    if currentMovie.isWatched {
                        Label("Visto", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                if currentMovie.personalRating > 0 {
                    Text("Nota pessoal: \(currentMovie.personalRating, specifier: "%.1f") / 10")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }

                Text("Sinopse")
                    .font(.headline)

                Text(currentMovie.overview.isEmpty ? "Sem sinopse disponível." : currentMovie.overview)
                    .font(.body)

                Button {
                    moviesVM.toggleWatched(currentMovie)
                } label: {
                    Label(currentMovie.isWatched ? "Marcar como não visto" : "Marcar como visto",
                          systemImage: currentMovie.isWatched ? "eye.slash" : "eye")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Detalhe")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Editar") {
                    showingEdit = true
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            NavigationStack {
                MovieFormView(mode: .edit(currentMovie))
            }
        }
    }
}
