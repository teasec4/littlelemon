//
//  CourseraLittleProjectV2App.swift
//  CourseraLittleProjectV2
//
//  Created by Максим Ковалев on 8/27/25.
//

import SwiftUI
import SwiftData

@main
struct CourseraLittleProjectV2App: App {
    
    // Глобальный контейнер со схемой моделей
    let sharedContainer: ModelContainer = {
        let schema = Schema([Profile.self, Category.self, MenuItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do { return try ModelContainer(for: schema, configurations: [config]) }
        catch { fatalError("ModelContainer error: \(error)") }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedContainer)
        }
    }
}
