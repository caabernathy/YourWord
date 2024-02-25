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
  var memorySources: [String] = []

  init(scripture: Scripture) {
    self.scripture = scripture
  }

  func mask(for bibleVersion: BibleVersion, days numberOfDaysToShow: Int) -> Bool {
    guard
      let scriptureText = scripture.version(for: bibleVersion) else { return false }
    let maskedTexts = maskScriptureText(scriptureText)
    let maskedSources = maskSriptureReference(scripture.passage)
    memoryTexts = Array(maskedTexts.prefix(numberOfDaysToShow))
    memorySources = Array(maskedSources.prefix(numberOfDaysToShow))
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
    var replacedSources: [String] = []
    // Mask source
    for i in 0..<ScriptureManager.shared.memorizeCount {
      // Modifiying source
      if !passage.maskingKey.isEmpty && passage.maskingKey[i] {
        // Switch up the masking, last element will be msked
        let lastRound = (i == ScriptureManager.shared.memorizeCount - 1)
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

  private func replaceWithUnderscore(text: String) -> String {
    return text.replacingOccurrences(of: "\\w", with: "_", options: .regularExpression)
  }

  private func formatSource(book: String, chapter: String, verses: String) -> String {
    return "\(book) \(chapter):\(verses)"
  }
}
