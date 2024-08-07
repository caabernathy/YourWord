/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftData

enum ScriptureSource: String, Codable {
  case system
  case userDefined
  case community
}

@Model
class Scripture: Codable {
  var id: UUID?
  var createdAt: Date?
  var passage: Passage
  var translations: [Translation]
  var source: ScriptureSource? = ScriptureSource.system
  var completed: Bool = false


  init(passage: Passage, translations: [Translation], source: ScriptureSource = .system, completed: Bool = false) {
    self.id = UUID()
    self.createdAt = Date()
    self.passage = passage
    self.translations = translations
    self.source = source
    self.completed = completed
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
    passage = try container.decode(Passage.self, forKey: .passage)
    translations = try container.decode([Translation].self, forKey: .translations)
    source = try container.decodeIfPresent(ScriptureSource.self, forKey: .source) ?? .system
    completed = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(passage, forKey: .passage)
    try container.encode(translations, forKey: .translations)
    try container.encode(source, forKey: .source)
  }

  func addTimeInterval(_ interval: TimeInterval) {
    if let date = self.createdAt {
      let adjustedDate = date.addingTimeInterval(interval)
      self.createdAt = adjustedDate
    }
  }

  // Method to get a version by name
  func version(for version: BibleVersion) -> Translation? {
    return translations.first { $0.name == version }
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case createdAt
    case passage
    case translations
    case source
    case completed
  }
}
