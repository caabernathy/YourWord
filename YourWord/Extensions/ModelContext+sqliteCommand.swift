//
//  ModelContext+sqliteCommand.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/20/23.
//

import Foundation
import SwiftData

extension ModelContext {
  var sqliteCommand: String {
    if let url = container.configurations.first?.url.path(percentEncoded: false) {
      "sqlite3 \"\(url)\""
    } else {
      "No SQLite database found."
    }
  }
}
