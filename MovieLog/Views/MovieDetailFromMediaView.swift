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

    private var existingMovie: Movie? {
        moviesVM.movies.first(where: { $0.tmdbID == item.tmdbID })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Poster limpo (sem overlay em cima)
                AsyncPosterView(path: item.posterPath)
                    .frame(maxWidth: .infinity)
                    .frame(height: 470)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

                // Infos abaixo do poster
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.title2.bold())

                    HStack {
                        Text(item.mediaType == .movie ? "Filme" : "Série")
                            .foregroundStyle(.secondary)
                        Spacer()
                        if let vote = item.voteAverage {
                            Text("TMDB \(String(format: "%.1f", vote))")
                                .foregroundStyle(.orange)
                        }
                    }

                    HStack(spacing: 8) {
                        chip(status.rawValue, .indigo)
                        chip(isWatched ? "Visto" : "Por ver", isWatched ? .green : .gray)
                        if existingMovie != nil { chip("Na minha lista", .blue) }
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Meu acompanhamento")
                        .font(.headline)

                    Picker("Estado", selection: $status) {
                        ForEach(MovieStatus.allCases) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)

                    Toggle("Marcar como visto", isOn: $isWatched)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Nota pessoal")
                            Spacer()
                            Text("\(String(format: "%.1f", personalRating))/10")
                                .fontWeight(.semibold)
                        }
                        Slider(value: $personalRating, in: 0...10, step: 0.5)
                            .tint(.orange)
                    }
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)

                // Sinopse
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sinopse")
                        .font(.headline)

                    Text(item.overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                         ? "Sem sinopse disponível."
                         : item.overview)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)

                // Ações
                if existingMovie == nil {
                    Button {
                        saveOrAddMovie()
                    } label: {
                        Label("Adicionar à minha lista", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }

                if let existingMovie {
                    Button(role: .destructive) {
                        moviesVM.deleteMovie(existingMovie)
                    } label: {
                        Label("Remover da minha lista", systemImage: "trash.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .principal) { EmptyView() } } // sem "Detalhe"
        .onAppear { loadInitialState() }
        .onChange(of: moviesVM.movies) { _, _ in loadInitialState() }
        .onChange(of: status) { _, _ in if existingMovie != nil { saveOrAddMovie() } }
        .onChange(of: isWatched) { _, _ in if existingMovie != nil { saveOrAddMovie() } }
        .onChange(of: personalRating) { _, _ in if existingMovie != nil { saveOrAddMovie() } }
    }

    private func chip(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.16))
            .foregroundStyle(color)
            .clipShape(Capsule())
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
