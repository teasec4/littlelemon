//
//  ContentView.swift
//  CourseraLittleProjectV2
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [Profile]

    var body: some View {
        NavigationStack {
            if let profile = profiles.first {
                HomePage() // передаём профиль вниз по иерархии
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Profile.self, Category.self, MenuItem.self], inMemory: true)
}
