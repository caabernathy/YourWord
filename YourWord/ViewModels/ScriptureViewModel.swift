/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@Observable class ScriptureViewModel {
  private var scripture: Scripture

  var memoryTexts: [String] = []
  var memoryReferences: [String] = []

  init(scripture: Scripture) {
    self.scripture = scripture
  }

  func mask(for bibleVersion: BibleVersion, days numberOfDaysToShow: Int) -> Bool {
    guard
      let scriptureVersion = scripture.version(for: bibleVersion) else { return false }
    let maskedTexts = maskScriptureText(scriptureVersion)
    let maskedReferences = maskSriptureReference(scripture.passage)
    memoryTexts = Array(maskedTexts.prefix(numberOfDaysToShow))
    memoryReferences = Array(maskedReferences.prefix(numberOfDaysToShow))
    return true
  }

  func maskScriptureText(_ version: Translation) -> [String] {
    var words = version.text.components(separatedBy: " ")
    var replacedWords: [String] = []
    // Mask words in a passage based on mask key configured during initialization
    for i in 0..<ScriptureManager.shared.memorizeCount {
      // Modifying words
      if !version.maskingKey.isEmpty {
        for j in 0..<words.count {
          if i >= version.maskingKey[j] {
            words[j] = replaceWithUnderscore(text: words[j])
          }
        }
      }
      replacedWords.append(words.joined(separator: " "))
    }
    return replacedWords
  }

  func maskSriptureReference(_ passage: Passage) -> [String] {
    var replacedReferences: [String] = []
    // Mask Reference
    for i in 0..<ScriptureManager.shared.memorizeCount {
      // Modifiying reference
      if !passage.maskingKey.isEmpty && passage.maskingKey[i] {
        // Switch up the masking, last element will be msked
        let lastRound = (i == ScriptureManager.shared.memorizeCount - 1)
        // Even, mask book
        let modifiedBook = lastRound || (i % 2 == 0) ? replaceWithUnderscore(text: passage.book) : passage.book
        // Odd, mask chapter and verses
        let modifiedChapter = lastRound || (i % 2 != 0) ? replaceWithUnderscore(text: String(passage.chapter)) : String(passage.chapter)
        let modifiedVerses = lastRound || (i % 2 != 0) ? replaceWithUnderscore(text: passage.verses) : passage.verses
        replacedReferences.append(formatReference(book: modifiedBook, chapter: modifiedChapter, verses: modifiedVerses))
      } else {
        // Reference not being modified
        replacedReferences.append(formatReference(book: passage.book, chapter: String(passage.chapter), verses: passage.verses))
      }
    }
    return replacedReferences
  }

  private func replaceWithUnderscore(text: String) -> String {
    return text.replacingOccurrences(of: "\\w", with: "_", options: .regularExpression)
  }

  private func formatReference(book: String, chapter: String, verses: String) -> String {
    return "\(book) \(chapter):\(verses)"
  }
}
