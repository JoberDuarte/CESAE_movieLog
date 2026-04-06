//
//  MainTabView.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MoviesListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchMoviesView()
                .tabItem {
                    Label("Pesquisar", systemImage: "magnifyingglass")
                }

            MyListView()
                .tabItem {
                    Label("Minha Lista", systemImage: "bookmark")
                }
        }
    }
}
