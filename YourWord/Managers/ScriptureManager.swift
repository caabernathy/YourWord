//
//  ScriptureManager.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/17/23.
//

import Foundation

@Observable class ScriptureManager {
  static let shared = ScriptureManager()
  let scriptureStore = ScriptureStore()

  let memorizeCount: Int = 7
  var scriptures: [Scripture] = []

  init() {
    loadInitialScripturesIfNeeded()
    loadScriptures()
  }

  func loadInitialScripturesIfNeeded() {
    scriptureStore.copyInitialDataIfNeeded()
  }

  func saveScriptures() {
    DispatchQueue.global().async {
      self.scriptureStore.save(scriptures: self.scriptures)
    }
  }

  func loadScriptures() {
    self.scriptures = scriptureStore.load()
    for i in 0..<self.scriptures.count {
      // Apply mask if needed
      if self.scriptures[i].key == nil {
        let scriptureKey = createKey(for: self.scriptures[i].text, count: memorizeCount)
        updateScripture(key: scriptureKey, at: i)
      }
    }
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

  func createKey(for text: String, count: Int) -> ScriptureKey {
    guard count > 0 else { return ScriptureKey(text: [], source: []) }
    let words = text.components(separatedBy: " ")
    var textKey = (1..<count).map { $0 }
    for _ in (count-1)..<words.count {
      textKey.append(Int.random(in: 1..<count))
    }
    textKey.shuffle()
    var sourceKey = (0..<count).map { _ in Bool.random() }
    sourceKey[0] = false
    sourceKey[count-1] = true
    return ScriptureKey(text: textKey, source: sourceKey)
  }

  func updateScripture(key: ScriptureKey, at index: Int) {
    if index >= 0 && index < scriptures.count {
      var updatedScripture = scriptures[index]
      updatedScripture.key = key
      scriptures[index] = updatedScripture
    }
  }

  func markScriptureMemorized(at index: Int) {
    if index >= 0 && index < scriptures.count {
      var updatedScripture = scriptures[index]
      updatedScripture.memorized = true
      scriptures[index] = updatedScripture
    }
  }
}
