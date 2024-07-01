/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftData

@Observable class ScriptureManager {
  enum FileConstants {
    static let initScriptureFileName = "StarterScriptures"
    static let bibleFileName = "Bible"
  }

  static let shared = ScriptureManager()

  let memorizeCount: Int = 7

  func loadInitialScriptures() -> [Scripture] {
    guard
      let bundleURL = Bundle.main.url(forResource: FileConstants.initScriptureFileName, withExtension: "json"),
      let scriptureData = try? Data(contentsOf: bundleURL),
      let scriptures = try? JSONDecoder().decode([Scripture].self, from: scriptureData)
    else {
      return []
    }
    // Add a slight delay so all the created date timestamps are not the same
    let timeIntervalIncrement = 0.001 // 1 millisecond
    for (index, scripture) in scriptures.enumerated() {
      scripture.addTimeInterval(TimeInterval(index) * timeIntervalIncrement)
    }
    return scriptures
  }

  func createTextMaskingKey(for text: String) -> [Int] {
    let words = text.components(separatedBy: " ")
    var textKey = (1..<memorizeCount).map { $0 }
    for _ in (memorizeCount-1)..<words.count {
      textKey.append(Int.random(in: 1..<memorizeCount))
    }
    textKey.shuffle()
    return textKey
  }

  func createReferenceMaskingKey() -> [Bool] {
    var referenceKey = (0..<memorizeCount).map { _ in Bool.random() }
    referenceKey[0] = false
    referenceKey[memorizeCount-1] = true
    return referenceKey
  }

  func storeScripture(_ scripture: Scripture, context: ModelContext) {
    context.insert(scripture)
    for (index, version) in scripture.translations.enumerated() {
      let scriptureTextKey = createTextMaskingKey(for: version.text)
      scripture.translations[index].maskingKey = scriptureTextKey
    }
    scripture.passage.maskingKey = createReferenceMaskingKey()
  }

  func loadBible() -> [Bible] {
    guard
      let bundleURL = Bundle.main.url(forResource: FileConstants.bibleFileName, withExtension: "json"),
      let bibleData = try? Data(contentsOf: bundleURL),
      let bible = try? JSONDecoder().decode(Bible.self, from: bibleData)
    else {
      return []
    }
    // Fpr now, just repeat NIV, ESV, NLT, KJV info
    let bibles: [Bible] = [
      Bible(version: .NIV, books: bible.books),
      Bible(version: .ESV, books: bible.books),
      Bible(version: .NLT, books: bible.books),
      Bible(version: .KJV, books: bible.books)
    ]
    return bibles
  }
}
