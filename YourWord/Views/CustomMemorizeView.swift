/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SwiftData

struct CustomMemorizeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var scriptures: [Scripture]

  var scripture: Scripture? {
    scriptures.first { $0.source == .userDefined && !$0.completed }
  }

  @State private var showScriptureSelector = false
  @State private var showScriptureDeleteConfirmation = false
  @State private var showToast = false

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
          if let _ = scripture {
            SaveButtonView() {
              markMemorizationAsCompleted()
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
    .toast(isPresented: $showToast, message: "Your Scripture has been saved.")
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

  private func markMemorizationAsCompleted() {
    guard let scripture = scripture else { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation {
        showToast.toggle()
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
      withAnimation {
        scripture.completed = true
      }
    }
  }
}

#Preview("No Scripture") {
  CustomMemorizeView()
    .emptyPreviewContainer()
}

#Preview("Scripture") {
  CustomMemorizeView()
    .previewContainer()
}
