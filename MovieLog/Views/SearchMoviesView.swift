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

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    TextField("Pesquisar...", text: $vm.query)
                        .textFieldStyle(.roundedBorder)
                    Button("Buscar") {
                        Task { await vm.search() }
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
                    Spacer()
                    ProgressView("A pesquisar...")
                    Spacer()
                } else if let error = vm.errorMessage {
                    Spacer()
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                    Spacer()
                } else if vm.results.isEmpty {
                    Spacer()
                    Text("Pesquisa por nome de filme ou série.")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(vm.results) { item in
                                NavigationLink {
                                    MovieDetailFromMediaView(item: item)
                                } label: {
                                    AsyncPosterView(path: item.posterPath)
                                        .frame(height: 160)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .clipped()
                                }
                                .buttonStyle(.plain)
                            }

                            // Trigger de paginação
                            if vm.canLoadMore {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .gridCellColumns(3)
                                    .onAppear {
                                        Task { await vm.loadMore() }
                                    }
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
