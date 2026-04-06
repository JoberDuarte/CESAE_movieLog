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
    @Published var selectedCategory: MediaCategory = .popular

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
            let response = try await service.fetchMediaPage(
                type: selectedType,
                category: selectedCategory,
                page: 1
            )

            results = response.items.filter {
                $0.title.localizedCaseInsensitiveContains(trimmed)
            }
        } catch {
            errorMessage = "Falha ao pesquisar. Verifica API key e internet."
            results = []
        }
    }

    func posterURL(for path: String?) -> URL? {
        service.fullPosterURL(path: path)
    }
}
