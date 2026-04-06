//
//  HomeFeedViewModel.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import Foundation
import Combine

@MainActor
final class HomeFeedViewModel: ObservableObject {
    @Published var items: [MediaItem] = []
    @Published var selectedType: MediaType = .movie
    @Published var selectedCategory: MediaCategory = .popular
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = TMDBService()
    private var page = 1
    private var totalPages = 1
    private var isRequestRunning = false

    var availableCategories: [MediaCategory] {
        switch selectedType {
        case .movie:
            return [.popular, .topRated, .nowPlaying, .upcoming]
        case .tv:
            return [.popular, .topRated, .onTheAir, .airingToday]
        }
    }

    func initialLoad() async {
        if items.isEmpty {
            await reload()
        }
    }

    func reload() async {
        page = 1
        totalPages = 1
        items = []
        await loadNextPage()
    }

    func loadNextPageIfNeeded(currentItem: MediaItem?) async {
        guard let currentItem else { return }
        guard let idx = items.firstIndex(of: currentItem) else { return }
        let threshold = max(items.count - 8, 0)
        if idx >= threshold {
            await loadNextPage()
        }
    }

    func loadNextPage() async {
        guard !isRequestRunning else { return }
        guard page <= totalPages else { return }

        isRequestRunning = true
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
            isRequestRunning = false
        }

        do {
            let response = try await service.fetchMediaPage(type: selectedType, category: selectedCategory, page: page)
            totalPages = response.totalPages
            items.append(contentsOf: response.items)
            page += 1
        } catch {
            errorMessage = "Erro ao carregar conteúdo."
        }
    }

    func changeType(_ type: MediaType) async {
        selectedType = type
        selectedCategory = availableCategories.first ?? .popular
        await reload()
    }

    func changeCategory(_ category: MediaCategory) async {
        selectedCategory = category
        await reload()
    }
}
