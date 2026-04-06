//
//  TMDBMovie.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import Foundation

struct TMDBMovie: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let vote_average: Double?
}
