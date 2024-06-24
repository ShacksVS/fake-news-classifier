//
//  FakeNewsClassifierApp.swift
//  FakeNewsClassifier
//
//  Created by Viktor Sovyak on 6/14/24.
//

import SwiftUI

@main
struct FakeNewsClassifierApp: App {
    @State private var sharedText: String?
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(sharedText: $sharedText)
                .onOpenURL { url in
                    handleURL(url)
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    private func handleURL(_ url: URL) {
        guard url.scheme == "fakenewsclassifier",
              let sharedText = url.host?.removingPercentEncoding else {
            return
        }
        print(sharedText)
        self.sharedText = sharedText
    }
}
