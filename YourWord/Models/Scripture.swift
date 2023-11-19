//
//  Scripture.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import Foundation

struct Scripture: Codable {
  var text: String
  var source: Source
  var key: ScriptureKey? // = ScriptureKey(text: [], source:  [])
  var memorized = false
}

struct Source: Codable {
  var book: String
  var chapter: String
  var verses: String
  var translation: String
}

struct ScriptureKey: Codable {
  var text: [Int]
  var source: [Bool]
}
