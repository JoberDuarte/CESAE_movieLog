//
//  TMDBService.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import Foundation

final class TMDBService {

    private let apiKey = "1dbfe4b73a5b00c637628661f5d9e944"
    private let baseURL = "https://api.themoviedb.org/3"
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500"

    func fullPosterURL(path: String?) -> URL? {
            guard let path, !path.isEmpty else { return nil }
            return URL(string: "\(imageBaseURL)\(path)")
        }

        private func endpoint(type: MediaType, category: MediaCategory) -> String {
            switch type {
            case .movie:
                switch category {
                case .popular: return "/movie/popular"
                case .topRated: return "/movie/top_rated"
                case .nowPlaying: return "/movie/now_playing"
                case .upcoming: return "/movie/upcoming"
                case .onTheAir: return "/movie/popular"      // fallback para movie
                case .airingToday: return "/movie/popular"   // fallback para movie
                }
            case .tv:
                switch category {
                case .popular: return "/tv/popular"
                case .topRated: return "/tv/top_rated"
                case .onTheAir: return "/tv/on_the_air"
                case .airingToday: return "/tv/airing_today"
                case .nowPlaying: return "/tv/popular"       // fallback para tv
                case .upcoming: return "/tv/popular"         // fallback para tv
                }
            }
        }

        func fetchMediaPage(type: MediaType, category: MediaCategory, page: Int) async throws -> MediaPageResult {
            let ep = endpoint(type: type, category: category)
            let lang = "pt-PT"
            let urlString = "\(baseURL)\(ep)?api_key=\(apiKey)&language=\(lang)&page=\(page)"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }

            let (data, _) = try await URLSession.shared.data(from: url)

            if type == .movie {
                let decoded = try JSONDecoder().decode(TMDBPagedResponse<TMDBMovieDTO>.self, from: data)
                let mapped = decoded.results.map {
                    MediaItem(
                        tmdbID: $0.id,
                        title: $0.title,
                        overview: $0.overview,
                        posterPath: $0.poster_path,
                        mediaType: .movie,
                        voteAverage: $0.vote_average
                    )
                }
                return MediaPageResult(items: mapped, page: decoded.page, totalPages: decoded.total_pages)
            } else {
                let decoded = try JSONDecoder().decode(TMDBPagedResponse<TMDBTVDTO>.self, from: data)
                let mapped = decoded.results.map {
                    MediaItem(
                        tmdbID: $0.id,
                        title: $0.name,
                        overview: $0.overview,
                        posterPath: $0.poster_path,
                        mediaType: .tv,
                        voteAverage: $0.vote_average
                    )
                }
                return MediaPageResult(items: mapped, page: decoded.page, totalPages: decoded.total_pages)
            }
        }
    }

    struct TMDBMovieDTO: Codable {
        let id: Int
        let title: String
        let overview: String
        let poster_path: String?
        let vote_average: Double?
    }

    struct TMDBTVDTO: Codable {
        let id: Int
        let name: String
        let overview: String
        let poster_path: String?
        let vote_average: Double?
    }
