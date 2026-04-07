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

    @State private var status: MovieStatus? = nil  
    @State private var isWatched: Bool = false
    @State private var personalRating: Double = 0

    private var existingMovie: Movie? {
        moviesVM.movies.first(where: { $0.tmdbID == item.tmdbID })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                AsyncPosterView(path: item.posterPath)
                    .frame(maxWidth: .infinity)
                    .frame(height: 470)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

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
                        if let status {
                            chip(status.rawValue, .indigo)
                        }
                        chip(isWatched ? "Visto" : "Por ver", isWatched ? .green : .gray)
                        if existingMovie != nil { chip("Na minha lista", .blue) }
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Meu acompanhamento")
                        .font(.headline)

                    // Picker manual sem pré-seleção
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Estado")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(MovieStatus.allCases) { s in
                                Button {
                                    status = (status == s) ? nil : s
                                    autoSaveIfExists()
                                } label: {
                                    Text(s.rawValue)
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(status == s ? Color.indigo : Color.indigo.opacity(0.1))
                                        .foregroundStyle(status == s ? .white : .indigo)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    Toggle("Marcar como visto", isOn: $isWatched)
                        .onChange(of: isWatched) { _, _ in autoSaveIfExists() }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Nota pessoal")
                            Spacer()
                            Text("\(String(format: "%.1f", personalRating))/10")
                                .fontWeight(.semibold)
                        }
                        Slider(value: $personalRating, in: 0...10, step: 0.5)
                            .tint(.orange)
                            .onChange(of: personalRating) { _, _ in autoSaveIfExists() }
                    }
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)

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
                } else {
                    Button(role: .destructive) {
                        moviesVM.deleteMovie(existingMovie!)
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
        .toolbar { ToolbarItem(placement: .principal) { EmptyView() } }
        .onAppear { loadInitialState() }
        .onChange(of: moviesVM.movies) { _, _ in loadInitialState() }
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
            status = nil       
            isWatched = false
            personalRating = 0
        }
    }

    private func autoSaveIfExists() {
        guard let m = existingMovie else { return }
        var updated = m
        updated.status = isWatched ? .watched : (status ?? m.status)
        updated.isWatched = isWatched
        updated.personalRating = personalRating
        updated.title = item.title
        updated.overview = item.overview
        updated.posterPath = item.posterPath
        moviesVM.updateMovie(updated)
    }

    private func saveOrAddMovie() {
        let newMovie = Movie(
            title: item.title,
            overview: item.overview,
            posterPath: item.posterPath,
            tmdbID: item.tmdbID,
            status: isWatched ? .watched : (status ?? .toWatch),
            personalRating: personalRating,
            isWatched: isWatched
        )
        moviesVM.addMovie(newMovie)
    }
}
