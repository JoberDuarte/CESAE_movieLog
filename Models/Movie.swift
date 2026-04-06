//
//  Movie.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//
import Foundation

enum MovieStatus: String, Codable, CaseIterable, Identifiable, Hashable {
    case toWatch = "Quero ver"
    case watching = "A ver"
    case watched = "Visto"

    var id: String { rawValue }
}

struct Movie: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var overview: String
    var posterPath: String?
    var tmdbID: Int?
    var status: MovieStatus
    var personalRating: Double
    var isWatched: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        overview: String,
        posterPath: String? = nil,
        tmdbID: Int? = nil,
        status: MovieStatus = .toWatch,
        personalRating: Double = 0.0,
        isWatched: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.tmdbID = tmdbID
        self.status = status
        self.personalRating = personalRating
        self.isWatched = isWatched
        self.createdAt = createdAt
    }
}
