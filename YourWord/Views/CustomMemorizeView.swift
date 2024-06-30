/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct CustomMemorizeView: View {
  @Environment(\.modelContext) private var modelContext
  var scripture: Scripture?

  @State private var showScriptureSelector = false

  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV

  var body: some View {
    ZStack {
      if let scripture = scripture {
        MemorizeView(scripture: scripture, isDailyReveal: false)
      } else {
        Text("Click + to add a Scripture to memorize.")
          .padding()
      }
      // Floating add button
      VStack {
        Spacer()
        HStack {
          Spacer()
          if let scripture = scripture {
            SaveButtonView() {
              scripture.completed = true
            }
          } else {
            AddButtonView() {
              showScriptureSelector = true
            }
          }
        }
      }
    }
    .sheet(isPresented: $showScriptureSelector) {
      ScriptureSelectorView(cancelAction: handleScriptureSelectorCancel) { book, chapter, startVerse, endVerse in
        fetchScripture(book: book, chapter: chapter, startVerse: startVerse, endVerse: endVerse)
      }
    }
  }

  private func handleScriptureSelectorCancel() {
    showScriptureSelector = false
  }

  private func fetchScripture(book: String, chapter: Int, startVerse: Int, endVerse: Int) {
    APIService.shared.fetchScripture(book: book, chapter: chapter, startVerse: startVerse, endVerse: endVerse) { result in
      switch result {
      case .success(let scripture):
        DispatchQueue.main.async {
          scripture.source = .userDefined
          ScriptureManager.shared.storeScripture(scripture, context: modelContext)
          showScriptureSelector = false
        }
      case .failure(let error):
        print("Error fetching scripture: \(error.localizedDescription)")
      }
    }
  }
}

#Preview {
  let _ = previewContainer
  return CustomMemorizeView(scripture: nil).modelContainer(previewContainer)
}
