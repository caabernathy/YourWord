/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftData

@Model
class Scripture: Codable {
  var id: UUID?
  var createdDate: Date?
  var passage: Passage
  var translations: [Translation]
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
