/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class Book: Identifiable, Codable, Comparable {
  var id: String
  var name: String
  var order: Int
  var chaptersAndVerses: [Int: Int]

  init(id: String, name: String, order: Int, chaptersAndVerses: [Int : Int]) {
    self.id = id
    self.name = name
    self.order = order
    self.chaptersAndVerses = chaptersAndVerses
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.order = try container.decode(Int.self, forKey: .order)
    self.chaptersAndVerses = try container.decode([Int : Int].self, forKey: .chaptersAndVerses)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(order, forKey: .order)
    try container.encode(chaptersAndVerses, forKey: .chaptersAndVerses)
  }

  // Implement Comparable for sorting
  static func < (lhs: Book, rhs: Book) -> Bool {
    return lhs.name < rhs.name
  }

  static func == (lhs: Book, rhs: Book) -> Bool {
    return lhs.name == rhs.name
  }

  var numberOfChapters: Int {
    chaptersAndVerses.count
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case order
    case chaptersAndVerses
  }
}
