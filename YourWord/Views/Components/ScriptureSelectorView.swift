/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureSelectorView: View {
  @Environment(\.modelContext) private var modelContext
  @Binding var scripture: Scripture?
  @Binding var showScriptureSelector: Bool

  let bibleComposition = ScriptureManager.shared.loadBibleComposition()
  let bible = ScriptureManager.shared.loadBible()

  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV

  @State private var bibleBooks: [BibleComposition] = []
  @State private var sortedBooks: [BibleComposition] = []
  @State private var numberOfChaptersInBook = 0
  @State private var numberOfVersesInChapter = 0
  @State private var selectedBookIndex = 0
  @State private var selectedChapter = 1
  @State private var selectedStartVerse = 1
  @State private var selectedEndVerse = 1
  @State private var isAlphabeticallySorted = false

  private func loadBibleBooks(for version: BibleVersion) {
    let versionBibleBooks = bible.filter { $0.version == bibleVersion }
    bibleBooks = bibleComposition.filter { composition in
      versionBibleBooks.contains(where: { $0.compositionId == composition.id })
    }
    displayBibleBooks()
  }

  private func displayBibleBooks() {
    selectedBookIndex = 0
    sortedBooks = isAlphabeticallySorted ? bibleBooks.sorted() : bibleBooks
    setupPickerSelections()
  }

  private func setupPickerSelections() {
    selectedChapter = 1
    selectedStartVerse = 1
    selectedEndVerse = 1
    let selectedBook = sortedBooks[selectedBookIndex]
    numberOfChaptersInBook = selectedBook.numberOfChapters
    numberOfVersesInChapter = selectedBook.chaptersAndVerses[selectedChapter] ?? 0
  }

  var body: some View {
    let passageTextExtra = selectedEndVerse > selectedStartVerse ? "-\(selectedEndVerse)" : ""
    Group {
      if sortedBooks.count > 0 {
        VStack {
          HStack {
            Spacer()
            Button(action: {
              showScriptureSelector = false
            }) {
              Image(systemName: "xmark")
                .foregroundColor(.gray)
                .padding()
            }
          }
          Spacer()

          HStack {
            Text("\(sortedBooks[selectedBookIndex].name) \(selectedChapter):\(selectedStartVerse)\(passageTextExtra)")
              .font(.title2)
              .padding()
            Spacer()
            Button(action: {
              fetchScripture()
            }) {
              Text("GO")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
          }
          .padding()

          HStack {
            Picker("Book", selection: $selectedBookIndex) {
              ForEach(0..<sortedBooks.count, id: \.self) { index in
                Text(sortedBooks[index].name).tag(index)
              }
            }
            Picker("Chapter", selection: $selectedChapter) {
              ForEach(1...numberOfChaptersInBook, id: \.self) { chapter in
                Text("\(chapter)").tag(chapter)
              }
            }
            Picker("Starting Verse", selection: $selectedStartVerse) {
              ForEach(1...numberOfVersesInChapter, id: \.self) { verse in
                Text("\(verse)").tag(verse)
              }
            }
            Picker("Ending Verse", selection: $selectedEndVerse) {
              ForEach(selectedStartVerse...numberOfVersesInChapter, id: \.self) { verse in
                Text("\(verse)").tag(verse)
              }
            }
          }
          .onChange(of: selectedBookIndex) {
            // Reset chapter and verse selections when the book changes
            setupPickerSelections()
          }
          .onChange(of: selectedChapter) {
            // Reset verse selections when the chapter changes
            selectedStartVerse = 1
            selectedEndVerse = 1
          }
          .pickerStyle(.wheel)

          Toggle(isOn: $isAlphabeticallySorted) {
            Text("Sort Books Alphabetically")
          }
          .padding()
          .onChange(of: isAlphabeticallySorted) {
            displayBibleBooks()
          }

          Spacer()
        }
      } else {
        Text("Nothing to see")
      }
    }
    .onAppear(perform: {
      loadBibleBooks(for: bibleVersion)
    })
  }

  func fetchScripture() {
    APIService.shared.fetchScripture(book: sortedBooks[selectedBookIndex].name, chapter: selectedChapter, startVerse: selectedStartVerse, endVerse: selectedEndVerse) { result in
      switch result {
      case .success(let scripture):
        DispatchQueue.main.async {
          modelContext.insert(scripture)
          for (index, version) in scripture.translations.enumerated() {
            let scriptureTextKey = ScriptureManager.shared.createTextMaskingKey(for: version.text)
            scripture.translations[index].maskingKey = scriptureTextKey
          }
          scripture.passage.maskingKey = ScriptureManager.shared.createReferenceMaskingKey()
          self.scripture = scripture
          showScriptureSelector = false
        }
      case .failure(let error):
        print("Error fetching scripture: \(error.localizedDescription)")
      }
    }
  }
}


#Preview {
  ScriptureSelectorView(scripture: .constant(nil), showScriptureSelector: .constant(true))
}
