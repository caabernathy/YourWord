//
//  Source.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/19/23.
//

import Foundation
import SwiftData

@Model
class Source: Codable {
  enum CodingKeys: CodingKey {
    case book
    case chapter
    case verses
    case translation
  }

  var book: String
  var chapter: String
  var verses: String
  var translation: String

  init(book: String, chapter: String, verses: String, translation: String) {
    self.book = book
    self.chapter = chapter
    self.verses = verses
    self.translation = translation
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    book = try container.decode(String.self, forKey: .book)
    chapter = try container.decode(String.self, forKey: .chapter)
    verses = try container.decode(String.self, forKey: .verses)
    translation = try container.decode(String.self, forKey: .translation)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(book, forKey: .book)
    try container.encode(chapter, forKey: .chapter)
    try container.encode(verses, forKey: .verses)
    try container.encode(translation, forKey: .translation)
  }
}
