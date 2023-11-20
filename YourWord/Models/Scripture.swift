//
//  Scripture.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import Foundation
import SwiftData

@Model
class Scripture: Codable {
  enum CodingKeys: CodingKey {
    case text
    case source
    case key
    case memorized
  }

  var text: String
  var source: Source
  var key: ScriptureKey?
  var memorized = false
  var maskedTexts: [String] = []
  var maskedSources: [String] = []

  init(text: String, source: Source, key: ScriptureKey? = nil, memorized: Bool = false) {
    self.text = text
    self.source = source
    self.key = key
    self.memorized = memorized
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    text = try container.decode(String.self, forKey: .text)
    source = try container.decode(Source.self, forKey: .source)
    key = try container.decodeIfPresent(ScriptureKey.self, forKey: .key)
    memorized = try container.decode(Bool.self, forKey: .memorized)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(text, forKey: .text)
    try container.encode(source, forKey: .source)
//    try container.encode(key, forKey: .key)
    try container.encode(memorized, forKey: .memorized)
  }
}
