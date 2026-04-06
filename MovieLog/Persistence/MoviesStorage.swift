//
//  MoviesStorage.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import Foundation

final class MoviesStorage {
    private let key = "movielog.saved.movies"

    func save(_ movies: [Movie]) {
        do {
            let data = try JSONEncoder().encode(movies)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Erro ao guardar filmes: \(error)")
        }
    }

    func load() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("Erro ao carregar filmes: \(error)")
            return []
        }
    }
}
