//
//  MoviesViewModel.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
import Foundation
import Combine
import SwiftUI

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    private let storage = MoviesStorage()

    init() {
        loadMovies()
    }

    func loadMovies() {
        movies = storage.load()
    }

    func addMovie(_ movie: Movie) {
        if let tmdbID = movie.tmdbID,
           movies.contains(where: { $0.tmdbID == tmdbID }) {
            return
        }
        movies.append(movie)
        saveMovies()
    }

    func updateMovie(_ updated: Movie) {
        guard let idx = movies.firstIndex(where: { $0.id == updated.id }) else { return }
        movies[idx] = updated
        saveMovies()
    }

    func deleteMovie(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
        saveMovies()
    }

    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveMovies()
    }

    func toggleWatched(_ movie: Movie) {
        guard let idx = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        movies[idx].isWatched.toggle()
        movies[idx].status = movies[idx].isWatched ? .watched : .toWatch
        saveMovies()
    }

    func saveMovies() {
        storage.save(movies)
    }


    func clearAll() {
        movies = []
        saveMovies()
    }
}
