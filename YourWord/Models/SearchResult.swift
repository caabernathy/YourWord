/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct SearchResultPassage: Codable, CustomStringConvertible {
  var book: String
  var chapter: Int
  var startVerse: Int
  var endVerse: Int

  var description: String {
    if startVerse == endVerse {
      return "\(book) \(chapter):\(startVerse)"
    } else {
      return "\(book) \(chapter):\(startVerse)-\(endVerse)"
    }
  }
}

struct SearchResultTranslation: Codable {
  var name: BibleVersion
  var text: String
}

struct SearchResultScripture: Codable, Identifiable {
  let id: UUID
  var passage: SearchResultPassage
  var translations: [SearchResultTranslation]

  init(passage: SearchResultPassage, translations: [SearchResultTranslation]) {
    self.id = UUID()
    self.passage = passage
    self.translations = translations
  }

  enum CodingKeys: String, CodingKey {
    case passage, translations
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = UUID()
    self.passage = try container.decode(SearchResultPassage.self, forKey: .passage)
    self.translations = try container.decode([SearchResultTranslation].self, forKey: .translations)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(passage, forKey: .passage)
    try container.encode(translations, forKey: .translations)
  }
}
