//
//  SearchMoviesView.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import SwiftUI

struct SearchMoviesView: View {
    @EnvironmentObject var moviesVM: MoviesViewModel
    @StateObject private var vm = SearchMoviesViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

   
    private var filteredMovies: [Movie] {
        if vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return moviesVM.movies // mostra todos no início
        }
        return moviesVM.movies.filter {
            $0.title.localizedCaseInsensitiveContains(vm.query)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    TextField("Pesquisar...", text: $vm.query)
                        .textFieldStyle(.roundedBorder)

                    Button("Buscar") {
                        Task { await vm.search() } // mantém botão de busca
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Picker("Tipo", selection: $vm.selectedType) {
                    Text("Filmes").tag(MediaType.movie)
                    Text("Séries").tag(MediaType.tv)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if vm.isLoading {
                    ProgressView("A pesquisar...")
                        .padding(.top, 8)
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                if filteredMovies.isEmpty && !vm.isLoading {
                    Spacer()
                    Text("Pesquisa por nome de filme ou série.")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(filteredMovies) { movie in
                                NavigationLink {
                                    MovieDetailFromMediaView(item: movie.asMediaItem)
                                } label: {
                                    PosterCardView(path: movie.posterPath)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle("Pesquisar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image("Image")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)

                        Text("Pesquisar")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onSubmit(of: .text) {
                Task { await vm.search() }
            }
        }
    }
}
