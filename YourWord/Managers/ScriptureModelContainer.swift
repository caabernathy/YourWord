//
//  ScriptureModelContainer.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/20/23.
//

import Foundation
import SwiftData

@MainActor

let sharedModelContainer: ModelContainer = {
  let schema = Schema([
    Scripture.self,
  ])
  let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

  do {
    let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

    // Debugging
    //    print(container.mainContext.sqliteCommand)

    // Make sure the persistent store is empty. If it's not, return the non-empty container.
    var scriptureFetchDescriptor = FetchDescriptor<Scripture>()
    scriptureFetchDescriptor.fetchLimit = 1
    guard try container.mainContext.fetch(scriptureFetchDescriptor).count == 0 else { return container }

    // If persistent store is not empty fetch starter scriptures
    let scriptures = ScriptureManager.shared.loadInitialScriptures()

    for scripture in scriptures {
      container.mainContext.insert(scripture)
    }
    for scripture in scriptures {
      let scriptureKey = ScriptureManager.shared.createKey(for: scripture.text)
      scripture.key = scriptureKey
    }
    return container
  } catch {
    fatalError("Could not create ModelContainer: \(error)")
  }
}()
