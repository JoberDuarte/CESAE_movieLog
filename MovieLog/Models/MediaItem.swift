//
//  MediaItem.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//
import Foundation

enum MediaType: String, CaseIterable, Identifiable, Codable, Hashable {
    case movie
    case tv

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .movie: return "Filmes"
        case .tv: return "Séries"
        }
    }
}

enum MediaCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case popular
    case topRated
    case nowPlaying
    case upcoming
    case onTheAir
    case airingToday

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .popular: return "Populares"
        case .topRated: return "TMBD"
        case .nowPlaying: return "Em cartaz"
        case .upcoming: return "Próximos"
        case .onTheAir: return "No ar"
        case .airingToday: return "Hoje"
        }
    }
}

struct TMDBPagedResponse<T: Codable>: Codable {
    let page: Int
    let results: [T]
    let total_pages: Int
}

struct MediaPageResult {
    let items: [MediaItem]
    let page: Int
    let totalPages: Int
}

struct MediaItem: Identifiable, Hashable {
    var id: String { "\(mediaType.rawValue)-\(tmdbID)" } // evita duplicado
    let tmdbID: Int
    let title: String
    let overview: String
    let posterPath: String?
    let mediaType: MediaType
    let voteAverage: Double?
}
