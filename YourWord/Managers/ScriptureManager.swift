//
//  ScriptureManager.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/17/23.
//

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
    return scriptures
  }

  func mask(scripture: Scripture) -> (words:[String], sources: [String])  {
    var words = scripture.text.components(separatedBy: " ")
    var replacedWords = [String]()
    var replacedSources = [String]()

    // Mask words in a passage based on modifiers configured during initialization
    for i in 0..<memorizeCount {
      // Modifying words
      if let scriptureKey = scripture.key {
        if !scriptureKey.text.isEmpty {
          for j in 0..<words.count {
            if i >= scriptureKey.text[j] {
              words[j] = replaceWithUnderscore(text: words[j])
            }
          }
        }
      }
      replacedWords.append(words.joined(separator: " "))
    }

    // Mask source
    for i in 0..<memorizeCount {
      // Modifiying source
      if let scriptureKey = scripture.key {
        if !scriptureKey.source.isEmpty && scriptureKey.source[i] {
          // Switch up the masking for the source elements, last element will be msked
          let lastRound = (i == memorizeCount - 1)
          // Even, mask book
          let modifiedBook = lastRound || (i % 2 == 0) ? replaceWithUnderscore(text: scripture.source.book) : scripture.source.book
          // Odd, mask chapter and verses
          let modifiedChapter = lastRound || (i % 2 != 0) ? replaceWithUnderscore(text: scripture.source.chapter) : scripture.source.chapter
          let modifiedVerses = lastRound || (i % 2 != 0) ? replaceWithUnderscore(text: scripture.source.verses) : scripture.source.verses
          replacedSources.append(formatSource(book: modifiedBook, chapter: modifiedChapter, verses: modifiedVerses, translation: scripture.source.translation))
          continue
        }
      }
      // Source not being modified
      replacedSources.append(formatSource(book: scripture.source.book, chapter: scripture.source.chapter, verses: scripture.source.verses, translation: scripture.source.translation))

    }

    return (words: replacedWords, sources: replacedSources)
  }

  private func formatSource(book: String, chapter: String, verses: String, translation: String) -> String {
    return "\(book) \(chapter):\(verses) \(translation)"
  }

  private func replaceWithUnderscore(text: String) -> String {
    return text.replacingOccurrences(of: "\\w", with: "_", options: .regularExpression)
  }

  func createKey(for text: String) -> ScriptureKey {
    let words = text.components(separatedBy: " ")
    var textKey = (1..<memorizeCount).map { $0 }
    for _ in (memorizeCount-1)..<words.count {
      textKey.append(Int.random(in: 1..<memorizeCount))
    }
    textKey.shuffle()
    var sourceKey = (0..<memorizeCount).map { _ in Bool.random() }
    sourceKey[0] = false
    sourceKey[memorizeCount-1] = true
    return ScriptureKey(text: textKey, source: sourceKey)
  }
}
