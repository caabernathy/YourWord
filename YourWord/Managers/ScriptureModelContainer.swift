/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

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
      for (index, translation) in scripture.translations.enumerated() {
        let scriptureTextKey = ScriptureManager.shared.createTextMaskingKey(for: translation.text)
        scripture.translations[index].maskingKey = scriptureTextKey
      }
      scripture.passage.maskingKey = ScriptureManager.shared.createReferenceMaskingKey()
    }
    return container
  } catch {
    fatalError("Could not create ModelContainer: \(error)")
  }
}()
