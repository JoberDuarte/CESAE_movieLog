//
//  MoviesListView.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import SwiftUI

struct MoviesListView: View {
    @StateObject private var vm = HomeFeedViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Picker("Tipo", selection: $vm.selectedType) {
                    ForEach(MediaType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.availableCategories) { category in
                            Button {
                                Task {
                                    await vm.changeCategory(category)
                                }
                            } label: {
                                Text(category.displayName)
                                    .font(.footnote.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(vm.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundStyle(vm.selectedCategory == category ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(vm.items) { item in
                            NavigationLink {
                                MovieDetailFromMediaView(item: item)
                            } label: {
                                PosterCardView(path: item.posterPath)
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                Task {
                                    await vm.loadNextPageIfNeeded(currentItem: item)
                                }
                            }
                        }

                        if vm.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .gridCellColumns(3)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("MovieLog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                }
            }
            .task {
                await vm.initialLoad()
            }
            .onChange(of: vm.selectedType) { _, newType in
                Task {
                    await vm.changeType(newType)
                }
            }
        }
    }
}

struct PosterCardView: View {
    let path: String?
    private let service = TMDBService()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.15))

            if let url = service.fullPosterURL(path: path) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Image(systemName: "film")
                            .foregroundStyle(.gray)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        Image(systemName: "film")
                            .foregroundStyle(.gray)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "film")
                    .foregroundStyle(.gray)
            }
        }
        .frame(height: 170)
        .clipped()
    }
}
