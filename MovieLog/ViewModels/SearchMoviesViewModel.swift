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
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var selectedType: MediaType = .movie

    private let service = TMDBService()
    private var currentPage = 1
    private var totalPages = 1
    private var lastQuery = ""

    var canLoadMore: Bool { currentPage < totalPages }

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = []
            return
        }

        // Reset para nova pesquisa
        currentPage = 1
        totalPages = 1
        lastQuery = trimmed
        results = []
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let page = try await service.searchMedia(query: trimmed, type: selectedType, page: 1)
            results = page.items
            currentPage = page.page
            totalPages = page.totalPages
        } catch {
            errorMessage = "Erro ao pesquisar. Verifica a ligação à internet."
            results = []
        }
    }

    func loadMore() async {
        guard canLoadMore, !isLoadingMore, !isLoading else { return }
        let nextPage = currentPage + 1
        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let page = try await service.searchMedia(query: lastQuery, type: selectedType, page: nextPage)
            results.append(contentsOf: page.items)
            currentPage = page.page
            totalPages = page.totalPages
        } catch {
            // falha silenciosa no load more
        }
    }
}
