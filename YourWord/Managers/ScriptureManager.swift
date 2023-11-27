/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@Observable class ScriptureManager {
  enum FileConstants {
    static let initScriptureFileName = "StarterScriptures"
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

  func maskScriptureText(_ translation: Translation) -> [String] {
    var words = translation.text.components(separatedBy: " ")
    var replacedWords: [String] = []
    // Mask words in a passage based on mask key configured during initialization
    for i in 0..<memorizeCount {
      // Modifying words
      if !translation.maskingKey.isEmpty {
        for j in 0..<words.count {
          if i >= translation.maskingKey[j] {
            words[j] = replaceWithUnderscore(text: words[j])
          }
        }
      }
      replacedWords.append(words.joined(separator: " "))
    }
    return replacedWords
  }

  func maskSriptureReference(_ passage: Passage) -> [String] {
    var replacedSources: [String] = []
    // Mask source
    for i in 0..<memorizeCount {
      // Modifiying source
      if !passage.maskingKey.isEmpty && passage.maskingKey[i] {
        // Switch up the masking, last element will be msked
        let lastRound = (i == memorizeCount - 1)
        // Even, mask book
        let modifiedBook = lastRound || (i % 2 == 0) ? replaceWithUnderscore(text: passage.book) : passage.book
        // Odd, mask chapter and verses
        let modifiedChapter = lastRound || (i % 2 != 0) ? replaceWithUnderscore(text: String(passage.chapter)) : String(passage.chapter)
        let modifiedVerses = lastRound || (i % 2 != 0) ? replaceWithUnderscore(text: passage.verses) : passage.verses
        replacedSources.append(formatSource(book: modifiedBook, chapter: modifiedChapter, verses: modifiedVerses))
      } else {
        // Source not being modified
        replacedSources.append(formatSource(book: passage.book, chapter: String(passage.chapter), verses: passage.verses))
      }
    }
    return replacedSources
  }

  private func formatSource(book: String, chapter: String, verses: String) -> String {
    return "\(book) \(chapter):\(verses)"
  }

  private func replaceWithUnderscore(text: String) -> String {
    return text.replacingOccurrences(of: "\\w", with: "_", options: .regularExpression)
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
}
