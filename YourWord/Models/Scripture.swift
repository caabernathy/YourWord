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
    case id
    case date
    case text
    case source
    case key
    case memorized
  }

  var id: UUID?
  var createdDate: Date?
  var text: String
  var source: Source
  var key: ScriptureKey?
  var memorized = false

  init(text: String, source: Source, key: ScriptureKey? = nil, memorized: Bool = false) {
    self.id = UUID()
    self.createdDate = Date()
    self.text = text
    self.source = source
    self.key = key
    self.memorized = memorized
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    createdDate = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
    text = try container.decode(String.self, forKey: .text)
    source = try container.decode(Source.self, forKey: .source)
    key = try container.decodeIfPresent(ScriptureKey.self, forKey: .key)
    memorized = try container.decode(Bool.self, forKey: .memorized)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(text, forKey: .text)
    try container.encode(source, forKey: .source)
    try container.encode(memorized, forKey: .memorized)
  }

  func addTimeInterval(_ interval: TimeInterval) {
    if let date = self.createdDate {
      let adjustedDate = date.addingTimeInterval(interval)
      self.createdDate = adjustedDate
    }
  }
}
