//
//  MovieDetailFromMediaView.swift
//  MovieLog
//
//  Created by iMac11 on 06/04/2026.
//
import SwiftUI

struct MovieDetailFromMediaView: View {
    @EnvironmentObject var moviesVM: MoviesViewModel
    let item: MediaItem

    @State private var status: MovieStatus = .toWatch
    @State private var isWatched: Bool = false
    @State private var personalRating: Double = 0

    // <- ESTA PROPRIEDADE resolve o erro
    private var existingMovie: Movie? {
        moviesVM.movies.first(where: { $0.tmdbID == item.tmdbID })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncPosterView(path: item.posterPath)
                    .frame(maxWidth: .infinity)
                    .frame(height: 420)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)

                Text(item.title)
                    .font(.title2.bold())
                    .padding(.horizontal)

                HStack {
                    Text(item.mediaType == .movie ? "Filme" : "Série")
                    Spacer()
                    if let vote = item.voteAverage {
                        Text("TMDB: \(vote, specifier: "%.1f")")
                            .foregroundStyle(.orange)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Meu acompanhamento")
                        .font(.headline)

                    Picker("Estado", selection: $status) {
                        ForEach(MovieStatus.allCases) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)

                    Toggle("Visto", isOn: $isWatched)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Nota pessoal: \(personalRating, specifier: "%.1f")")
                        Slider(value: $personalRating, in: 0...10, step: 0.5)
                    }
                }
                .padding(.horizontal)

                Text("Sinopse")
                    .font(.headline)
                    .padding(.horizontal)

                Text(item.overview.isEmpty ? "Sem sinopse disponível." : item.overview)
                    .padding(.horizontal)

                Button {
                    saveOrAddMovie()
                } label: {
                    Label(existingMovie == nil ? "Adicionar à minha lista" : "Guardar alterações na minha lista",
                          systemImage: existingMovie == nil ? "plus" : "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)

                if let existingMovie {
                    Button(role: .destructive) {
                        moviesVM.deleteMovie(existingMovie)
                    } label: {
                        Label("Remover da minha lista", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Detalhe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadInitialState()
        }
    }

    private func loadInitialState() {
        if let m = existingMovie {
            status = m.status
            isWatched = m.isWatched
            personalRating = m.personalRating
        } else {
            status = .toWatch
            isWatched = false
            personalRating = item.voteAverage ?? 0
        }
    }

    private func saveOrAddMovie() {
        if let m = existingMovie {
            var updated = m
            updated.status = isWatched ? .watched : status
            updated.isWatched = isWatched
            updated.personalRating = personalRating
            updated.title = item.title
            updated.overview = item.overview
            updated.posterPath = item.posterPath
            moviesVM.updateMovie(updated)
        } else {
            let newMovie = Movie(
                title: item.title,
                overview: item.overview,
                posterPath: item.posterPath,
                tmdbID: item.tmdbID,
                status: isWatched ? .watched : status,
                personalRating: personalRating,
                isWatched: isWatched
            )
            moviesVM.addMovie(newMovie)
        }
    }
}
