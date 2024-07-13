/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureSelectorView: View {
  @Binding var isLoading: Bool
  var submitAction: (String, Int, Int, Int) -> Void

  let bibles = ScriptureManager.shared.loadBible()

  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV

  @State private var bibleBooks: [Book] = []
  @State private var sortedBooks: [Book] = []
  @State private var numberOfChaptersInBook = 0
  @State private var numberOfVersesInChapter = 0
  @State private var selectedBookIndex = 0
  @State private var selectedChapter = 1
  @State private var selectedStartVerse = 1
  @State private var selectedEndVerse = 1
  @State private var isAlphabeticallySorted = false
  @State private var selectedTestamentFilter: TestamentFilter = .all

  private func loadBibleBooks(for version: BibleVersion) {
    let versionBible = bibles.first { $0.version == bibleVersion }
    if let versionBible = versionBible {
      bibleBooks = versionBible.books
    }
    displayBibleBooks()
  }

  private func displayBibleBooks() {
    selectedBookIndex = 0
    let filteredByTestament = filterBooks(bibleBooks)
    let sortedByName = filteredByTestament.sorted()
    let sortedByOrder = filteredByTestament.sorted { $0.order < $1.order }
    sortedBooks = isAlphabeticallySorted ? sortedByName : sortedByOrder
    onSelectedBookChange()
  }

  private func onSelectedBookChange() {
    selectedChapter = 1
    onSelectedChapterChange()
  }

  private func onSelectedChapterChange() {
    selectedStartVerse = 1
    selectedEndVerse = 1
    let selectedBook = sortedBooks[selectedBookIndex]
    numberOfChaptersInBook = selectedBook.numberOfChapters
    numberOfVersesInChapter = selectedBook.chaptersAndVerses[selectedChapter] ?? 0
  }

  private func filterBooks(_ books: [Book]) -> [Book] {
    switch selectedTestamentFilter {
    case .all:
      return books
    case .testament(let testament):
      return books.filter { $0.testament == testament }
    }
  }

  private func onSubmit() {
    isLoading = true
    submitAction(sortedBooks[selectedBookIndex].name, selectedChapter, selectedStartVerse, selectedEndVerse)
  }

  var body: some View {
    let passageTextExtra = selectedEndVerse > selectedStartVerse ? "-\(selectedEndVerse)" : ""
    Group {
      if sortedBooks.count > 0 {
        VStack(spacing: 10) {
          HStack {
            Text("\(sortedBooks[selectedBookIndex].name) \(selectedChapter):\(selectedStartVerse)\(passageTextExtra)")
              .font(.title2)
              .padding()
            Spacer()
            Button(action: {
              onSubmit()
            }) {
              if isLoading {
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle(tint: .white))
                  .padding([.leading, .trailing], 20)
                  .padding()
              } else {
                Text("GO")
                  .foregroundColor(.white)
                  .padding([.leading, .trailing], 17)
                  .padding()
              }
            }
            .background(Color.blue)
            .cornerRadius(10)
            .disabled(isLoading)
          }
          .padding(.horizontal)


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
            onSelectedBookChange()
          }
          .onChange(of: selectedChapter) {
            // Reset verse selections when the chapter changes
            onSelectedChapterChange()
          }
          .pickerStyle(.wheel)
          .frame(height: 200)
          .padding(.top, -20)

          TestamentFilterView(selectedFilter: $selectedTestamentFilter)
            .onChange(of: selectedTestamentFilter) {
              displayBibleBooks()
            }

          Toggle(isOn: $isAlphabeticallySorted) {
            Text("Sort Books Alphabetically")
          }
          .padding(.horizontal)
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
}


#Preview("Default") {
  ScriptureSelectorView(
    isLoading: .constant(false),
    submitAction: {_,_,_,_ in }
  )
}

#Preview("Loading") {
  ScriptureSelectorView(
    isLoading: .constant(true),
    submitAction: {_,_,_,_ in }
  )
}
