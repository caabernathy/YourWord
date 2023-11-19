//
//  ScriptureStore.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/18/23.
//

import Foundation

class ScriptureStore {
  enum FileConstants {
    static let initScriptureFileName = "StarterScriptures"
    static let scriptureFileName = "scriptures.json"
  }

  func save(scriptures: [Scripture]) {
    do {
      let documentsDirectory = getDocumentsDirectory()
      let storageURL = documentsDirectory.appendingPathComponent(FileConstants.scriptureFileName)
      let scriptureData = try JSONEncoder().encode(scriptures)
      do {
        try scriptureData.write(to: storageURL)
      } catch {
        print("Couldn't write to File Storage")
      }
    } catch {
      print("Couldn't encode scripture data")
    }
  }

  func load() -> [Scripture] {
    let documentsDirectory = getDocumentsDirectory()
    let storageURL = documentsDirectory.appendingPathComponent(FileConstants.scriptureFileName)
    guard
      let scriptureData = try? Data(contentsOf: storageURL),
      let scriptures = try? JSONDecoder().decode([Scripture].self, from: scriptureData)
    else {
      return []
    }
    return scriptures
  }

  func copyInitialDataIfNeeded() {
    let documentsDirectory = getDocumentsDirectory()
    let storageURL = documentsDirectory.appendingPathComponent(FileConstants.scriptureFileName)
    let fileManager = FileManager.default

    // Check if file exists in the documents directory
    if !fileManager.fileExists(atPath: storageURL.path) {
      // File does not exist, copy from bundle
      guard let bundleURL = Bundle.main.url(forResource: FileConstants.initScriptureFileName, withExtension: "json") else { return }

      do {
        try fileManager.copyItem(at: bundleURL, to: storageURL)
        print("Initial data copied to Documents directory.")
      } catch {
        print("Error copying file: \(error)")
      }
    }
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
