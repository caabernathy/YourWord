/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
  do {
    let schema = Schema([
//      Translation.self,
//      Passage.self,
      Scripture.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

    for scripture in PreviewData.scriptures {
      container.mainContext.insert(scripture)
    }

    return container
  } catch {
    fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
  }
}()
