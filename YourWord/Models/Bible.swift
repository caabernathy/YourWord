/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class Bible: Identifiable, Codable, Comparable {
  let id: UUID?
  var compositionId: String
  var bookOrder: Int
  var version: BibleVersion

  init(compositionId: String, bookOrder: Int, version: BibleVersion) {
    self.id = UUID()
    self.compositionId = compositionId
    self.bookOrder = bookOrder
    self.version = version
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    compositionId = try container.decode(String.self, forKey: .compositionId)
    bookOrder = try container.decode(Int.self, forKey: .bookOrder)
    version = try container.decode(BibleVersion.self, forKey: .version)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(compositionId, forKey: .compositionId)
    try container.encode(bookOrder, forKey: .bookOrder)
    try container.encode(version, forKey: .version)
  }

  // Implement Comparable for sorting
  static func < (lhs: Bible, rhs: Bible) -> Bool {
    return lhs.bookOrder < rhs.bookOrder
  }

  static func == (lhs: Bible, rhs: Bible) -> Bool {
    return lhs.bookOrder == rhs.bookOrder
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case compositionId
    case bookOrder
    case version
  }
}
