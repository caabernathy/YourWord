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
    VStack {
      if let scripture = scripture {
        MemorizeView(scripture: scripture, isDailyReveal: false)
      } else {
        Text("You haven't set up any scriptures to memorize.")
          .padding()
      }
      Button(action: {
        showScriptureSelector = true
      }) {
        Text("New Scripture")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
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
  CustomMemorizeView(scripture: nil)
}
