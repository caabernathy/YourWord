//
//  Scripture.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import Foundation
import SwiftData

enum BibleTranslation: String, Codable, CaseIterable, Identifiable {
  case NIV
  case ESV
  case NLT
  case KJV

  var id: Self { self }
}

@Model
class Passage: Codable, CustomStringConvertible {
  var id: UUID?
  var book: String
  var chapter: Int
  var startVerse: Int
  var endVerse: Int
  var maskingKey: [Bool] = []

  init(book: String, chapter: Int, startVerse: Int, endVerse: Int) {
    self.id = UUID()
    self.book = book
    self.chapter = chapter
    self.startVerse = startVerse
    self.endVerse = endVerse
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    book = try container.decode(String.self, forKey: .book)
    chapter = try container.decode(Int.self, forKey: .chapter)
    startVerse = try container.decode(Int.self, forKey: .startVerse)
    endVerse = try container.decode(Int.self, forKey: .endVerse)
    maskingKey = try container.decodeIfPresent([Bool].self, forKey: .maskingKey) ?? []
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(book, forKey: .book)
    try container.encode(chapter, forKey: .chapter)
    try container.encode(startVerse, forKey: .startVerse)
    try container.encode(endVerse, forKey: .endVerse)
  }

  var description: String {
    if startVerse == endVerse {
      return "\(book) \(chapter):\(startVerse)"
    } else {
      return "\(book) \(chapter):\(startVerse)-\(endVerse)"
    }
  }

  var verses: String {
    if startVerse == endVerse {
      return "\(startVerse)"
    } else {
      return "\(startVerse)-\(endVerse)"
    }
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case book
    case chapter
    case startVerse
    case endVerse
    case maskingKey
  }
}

@Model
class Translation: Codable {
  var name: BibleTranslation
  var text: String
  var maskingKey: [Int] = []

  init(name: BibleTranslation, text: String) {
    self.name = name
    self.text = text
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(BibleTranslation.self, forKey: .name)
    text = try container.decode(String.self, forKey: .text)
    maskingKey = try container.decodeIfPresent([Int].self, forKey: .maskingKey) ?? []
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(text, forKey: .text)
  }

  private enum CodingKeys: String, CodingKey {
    case name
    case text
    case maskingKey
  }
}

@Model
class Scripture: Codable {
  var id: UUID?
  var createdDate: Date?
  var passage: Passage
  var translations: [Translation]
  var selectedTranslation: BibleTranslation = BibleTranslation.NIV
  var isMemorized: Bool = false
  var isFavorite: Bool = false

  init(passage: Passage, translations: [Translation]) {
    self.id = UUID()
    self.createdDate = Date()
    self.passage = passage
    self.translations = translations
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    createdDate = try container.decodeIfPresent(Date.self, forKey: .createdDate) ?? Date()
    passage = try container.decode(Passage.self, forKey: .passage)
    translations = try container.decode([Translation].self, forKey: .translations)
    isMemorized = try container.decodeIfPresent(Bool.self, forKey: .isMemorized) ?? false
    isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(passage, forKey: .passage)
    try container.encode(translations, forKey: .translations)
  }

  func addTimeInterval(_ interval: TimeInterval) {
    if let date = self.createdDate {
      let adjustedDate = date.addingTimeInterval(interval)
      self.createdDate = adjustedDate
    }
  }

  // Method to get a translation by name
  func translation(for name: BibleTranslation) -> Translation? {
    return translations.first { $0.name == name }
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case createdDate
    case passage
    case translations
    case isMemorized
    case isFavorite
  }
}
