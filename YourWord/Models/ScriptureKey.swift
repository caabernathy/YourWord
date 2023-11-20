//
//  ScriptureKey.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/19/23.
//

import Foundation
import SwiftData

@Model
class ScriptureKey: Codable {
  enum CodingKeys: CodingKey {
    case text
    case source
  }

  var text: [Int]
  var source: [Bool]

  init(text: [Int], source: [Bool]) {
    self.text = text
    self.source = source
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    text = try container.decode([Int].self, forKey: .text)
    source = try container.decode([Bool].self, forKey: .source)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(text, forKey: .text)
    try container.encode(source, forKey: .source)
  }
}
