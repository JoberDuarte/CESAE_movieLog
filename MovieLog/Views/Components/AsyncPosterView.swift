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

    @State private var uiImage: UIImage? = nil
    @State private var isLoading = false

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                    ProgressView()
                }
            } else {
                placeholder
            }
        }
        .onAppear { loadImage() }
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
            Image(systemName: "film")
                .foregroundStyle(.gray)
        }
    }

    private func loadImage() {
        guard let path,
              let url = URL(string: "\(imageBase)\(path)"),
              uiImage == nil,
              !isLoading else { return }

        // Verifica cache primeiro
        if let cached = ImageCache.shared.get(url) {
            uiImage = cached
            return
        }

        isLoading = true
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                isLoading = false
                if let data, let img = UIImage(data: data) {
                    ImageCache.shared.set(img, for: url)
                    uiImage = img
                }
            }
        }.resume()
    }
}

// Cache simples em memória
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    private init() {}

    func get(_ url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
