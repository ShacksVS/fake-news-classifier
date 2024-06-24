//
//  FakeNewsClassifierApp.swift
//  FakeNewsClassifier
//
//  Created by Viktor Sovyak on 6/14/24.
//

import SwiftUI

@main
struct FakeNewsClassifierApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
