//
//  MediaItem.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//
import Foundation

enum MediaType: String, CaseIterable, Identifiable, Codable, Hashable {
    case movie = "Filmes"
    case tv = "Séries"

    var id: String { rawValue }
}

enum MediaCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case popular = "Popular"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case onTheAir = "On The Air"
    case airingToday = "Airing Today"

    var id: String { rawValue }
}

struct TMDBPagedResponse<T: Codable>: Codable {
    let page: Int
    let results: [T]
    let total_pages: Int
}

struct MediaItem: Identifiable, Hashable {
    // id único para SwiftUI
    var id: String { "\(mediaType.rawValue)-\(tmdbID)" }

    let tmdbID: Int
    let title: String
    let overview: String
    let posterPath: String?
    let mediaType: MediaType
    let voteAverage: Double?
}
