//
//  MoviesViewModel.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
import Foundation
import SwiftUI
import Combine

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    private let storage = MoviesStorage()
    private let hasInitializedKey = "hasInitializedMoviesStorage_v1"

    init() {
        let hasInitialized = UserDefaults.standard.bool(forKey: hasInitializedKey)

        if !hasInitialized {
            // primeira execução: começa vazio
            storage.save([])
            UserDefaults.standard.set(true, forKey: hasInitializedKey)
        }

        loadMovies()
    }

    func loadMovies() {
        movies = storage.load()
    }

    func addMovie(_ movie: Movie) {
        if let tmdb = movie.tmdbID, movies.contains(where: { $0.tmdbID == tmdb }) { return }
        movies.append(movie)
        saveMovies()
    }

    func updateMovie(_ updated: Movie) {
        guard let idx = movies.firstIndex(where: { $0.id == updated.id }) else { return }
        movies[idx] = updated
        saveMovies()
    }

    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveMovies()
    }

    private func saveMovies() {
        storage.save(movies)
    }
}
