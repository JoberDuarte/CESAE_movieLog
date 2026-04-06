//
//  SearchMoviesViewModel.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import Foundation
import Combine

@MainActor
final class SearchMoviesViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [MediaItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var selectedType: MediaType = .movie

    private let service = TMDBService()

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = []
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let page = try await service.fetchMediaPage(
                type: selectedType,
                category: .popular,
                page: 1
            )

            results = page.items.filter {
                $0.title.localizedCaseInsensitiveContains(trimmed)
            }
        } catch {
            errorMessage = "Erro ao pesquisar. Verifica API key e internet."
            results = []
        }
    }
}
