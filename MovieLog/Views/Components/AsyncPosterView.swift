//
//  AsyncPosterView.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import SwiftUI

struct AsyncPosterView: View {
    let path: String?
    private let imageBase = "https://image.tmdb.org/t/p/w500"

    var body: some View {
        Group {
            if let path,
               let url = URL(string: "\(imageBase)\(path)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        placeholder
                    case .empty:
                        ProgressView()
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
            Image(systemName: "film")
                .foregroundStyle(.gray)
        }
    }
}
