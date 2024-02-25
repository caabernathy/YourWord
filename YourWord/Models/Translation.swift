/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

import SwiftData

enum BibleVersion: String, Codable, CaseIterable, Identifiable {
  case NIV
  case ESV
  case NLT
  case KJV

  var id: Self { self }
}

@Model
class Translation: Codable {
  @Attribute(originalName: "name") var version: BibleVersion
  var text: String
  var maskingKey: [Int] = []

  init(name: BibleVersion, text: String) {
    self.version = name
    self.text = text
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    version = try container.decode(BibleVersion.self, forKey: .version)
    text = try container.decode(String.self, forKey: .text)
    maskingKey = try container.decodeIfPresent([Int].self, forKey: .maskingKey) ?? []
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(version, forKey: .version)
    try container.encode(text, forKey: .text)
  }

  private enum CodingKeys: String, CodingKey {
    case version
    case text
    case maskingKey
  }
}
