//
//  MovieFormView.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import SwiftUI

enum MovieFormMode {
    case create(TMDBMovie?)
    case edit(Movie)
}

struct MovieFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var moviesVM: MoviesViewModel

    let mode: MovieFormMode

    @State private var title: String = ""
    @State private var overview: String = ""
    @State private var posterPath: String = ""
    @State private var tmdbID: Int?
    @State private var status: MovieStatus = .toWatch
    @State private var personalRating: Double = 0
    @State private var isWatched: Bool = false

    var body: some View {
        Form {
            Section("Informação") {
                TextField("Título", text: $title)
                TextField("Sinopse", text: $overview, axis: .vertical)
                    .lineLimit(3...6)
                TextField("Poster path (opcional)", text: $posterPath)
            }

            Section("Estado") {
                Picker("Estado", selection: $status) {
                    ForEach(MovieStatus.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }

                Toggle("Visto", isOn: $isWatched)

                VStack(alignment: .leading) {
                    Text("Nota pessoal: \(personalRating, specifier: "%.1f")")
                    Slider(value: $personalRating, in: 0...10, step: 0.5)
                }
            }
        }
        .navigationTitle(modeTitle)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancelar") { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Guardar") {
                    save()
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear {
            setupInitialValues()
        }
    }

    private var modeTitle: String {
        switch mode {
        case .create: return "Novo Filme"
        case .edit: return "Editar Filme"
        }
    }

    private func setupInitialValues() {
        switch mode {
        case .create(let tmdbMovie):
            guard let m = tmdbMovie else { return }
            title = m.title
            overview = m.overview
            posterPath = m.poster_path ?? ""
            tmdbID = m.id
            personalRating = m.vote_average ?? 0
            status = .toWatch
            isWatched = false

        case .edit(let movie):
            title = movie.title
            overview = movie.overview
            posterPath = movie.posterPath ?? ""
            tmdbID = movie.tmdbID
            status = movie.status
            personalRating = movie.personalRating
            isWatched = movie.isWatched
        }
    }

    private func save() {
        switch mode {
        case .create:
            let newMovie = Movie(
                title: title,
                overview: overview,
                posterPath: posterPath.isEmpty ? nil : posterPath,
                tmdbID: tmdbID,
                status: isWatched ? .watched : status,
                personalRating: personalRating,
                isWatched: isWatched
            )
            moviesVM.addMovie(newMovie)

        case .edit(let oldMovie):
            var updated = oldMovie
            updated.title = title
            updated.overview = overview
            updated.posterPath = posterPath.isEmpty ? nil : posterPath
            updated.tmdbID = tmdbID
            updated.status = isWatched ? .watched : status
            updated.personalRating = personalRating
            updated.isWatched = isWatched
            moviesVM.updateMovie(updated)
        }

        dismiss()
    }
}
