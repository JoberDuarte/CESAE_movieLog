//
//  MovieLogApp.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
//

import SwiftUI

@main
struct MovieLogApp: App {
    @StateObject private var moviesVM = MoviesViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(moviesVM)
        }
    }
}
