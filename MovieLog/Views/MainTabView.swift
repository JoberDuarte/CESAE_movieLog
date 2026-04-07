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
            NavigationStack {
                MoviesListView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                SearchMoviesView()
            }
            .tabItem {
                Label("Pesquisar", systemImage: "magnifyingglass")
            }

            NavigationStack {
                MyListView()
            }
            .tabItem {
                Label("Minha Lista", systemImage: "bookmark")
            }
        }
    }
}
