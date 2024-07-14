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
  @State private var showScriptureDeleteConfirmation = false
  
  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV
  
  var body: some View {
    ZStack {
      if let scripture = scripture {
        MemorizeView(scripture: scripture, isDailyReveal: false)
      } else {
        Text("Click + to add a Scripture to memorize.")
          .padding()
      }
      // Floating action button
      VStack {
        Spacer()
        HStack {
          if let _ = scripture {
            DeleteButtonView() {
              showScriptureDeleteConfirmation = true
            }
          }
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
      ScriptureAddView(
        cancelAction: handleScriptureSelectorCancel,
        addAction: { scripture in
          saveScripture(scripture)
        }
      )
    }
    .alert(isPresented: $showScriptureDeleteConfirmation) {
      Alert(
        title: Text("Remove Scripture"),
        message: Text("Are you sure you want to remove this scripture?"),
        primaryButton: .destructive(Text("Remove")) {
          deleteScripture()
        },
        secondaryButton: .cancel()
      )
    }
  }
  
  private func handleScriptureSelectorCancel() {
    showScriptureSelector = false
  }
  
  private func saveScripture(_ scripture: Scripture) {
    scripture.source = .userDefined
    ScriptureManager.shared.storeScripture(scripture, context: modelContext)
    showScriptureSelector = false
  }
  
  private func deleteScripture() {
    if let scripture = scripture {
      ScriptureManager.shared.removeScripture(scripture, context: modelContext)
    }
  }
}

#Preview("No Scripture") {
  let _ = previewContainer
  return CustomMemorizeView(scripture: nil).modelContainer(previewContainer)
}

#Preview("Scripture") {
  let _ = previewContainer
  let scripture = PreviewData.scriptures.first
  return CustomMemorizeView(
    scripture: scripture
  ).modelContainer(previewContainer)
}
