/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class Bible: Identifiable, Codable {
  let id: UUID?
  var version: BibleVersion
  var books: [Book]

  init(version: BibleVersion, books: [Book]) {
    self.id = UUID()
    self.version = version
    self.books = books
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    version = try container.decode(BibleVersion.self, forKey: .version)
    books = try container.decode([Book].self, forKey: .books)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(version, forKey: .version)
    try container.encode(books, forKey: .books)
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case version
    case books
  }
}
