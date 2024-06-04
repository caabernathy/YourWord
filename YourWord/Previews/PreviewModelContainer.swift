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
    for scripture in PreviewData.scriptures {
      for (index, version) in scripture.translations.enumerated() {
        let scriptureTextKey = ScriptureManager.shared.createTextMaskingKey(for: version.text)
        scripture.translations[index].maskingKey = scriptureTextKey
      }
      scripture.passage.maskingKey = ScriptureManager.shared.createReferenceMaskingKey()
    }

    return container
  } catch {
    fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
  }
}()
