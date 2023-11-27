/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftData

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
