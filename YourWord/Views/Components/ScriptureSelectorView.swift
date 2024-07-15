/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

@Observable
class ScriptureSelectionState {
  var selectedBookIndex: Int = 0
  var selectedChapter: Int = 1
  var selectedStartVerse: Int = 1
  var selectedEndVerse: Int = 1
  var isAlphabeticallySorted: Bool = false
  var selectedTestamentFilter: TestamentFilter = .all

  init(selectedBookIndex: Int = 0, selectedChapter: Int = 1, selectedStartVerse: Int = 1, selectedEndVerse: Int = 1, isAlphabeticallySorted: Bool = false, selectedTestamentFilter: TestamentFilter = .all) {
    self.selectedBookIndex = selectedBookIndex
    self.selectedChapter = selectedChapter
    self.selectedStartVerse = selectedStartVerse
    self.selectedEndVerse = selectedEndVerse
    self.isAlphabeticallySorted = isAlphabeticallySorted
    self.selectedTestamentFilter = selectedTestamentFilter
  }
}

struct ScriptureSelectorView: View {
  @Binding var isLoading: Bool
  @Binding var state: ScriptureSelectionState
  var submitAction: (String, Int, Int, Int) -> Void

  let bibles = ScriptureManager.shared.loadBible()

  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV

  @State private var bibleBooks: [Book] = []
  @State private var sortedBooks: [Book] = []
  @State private var numberOfChaptersInBook = 0
  @State private var numberOfVersesInChapter = 0

  private func loadBibleBooks(for version: BibleVersion) {
    let versionBible = bibles.first { $0.version == bibleVersion }
    if let versionBible = versionBible {
      bibleBooks = versionBible.books
    }
    setupBibleBooks()
    setupChapterVerses()
  }

  private func setupBibleBooks() {
    let filteredByTestament = filterBooks(bibleBooks)
    let sortedByName = filteredByTestament.sorted()
    let sortedByOrder = filteredByTestament.sorted { $0.order < $1.order }
    sortedBooks = state.isAlphabeticallySorted ? sortedByName : sortedByOrder
  }

  private func setupChapterVerses() {
    let selectedBook = sortedBooks[state.selectedBookIndex]
    numberOfChaptersInBook = selectedBook.numberOfChapters
    numberOfVersesInChapter = selectedBook.chaptersAndVerses[state.selectedChapter] ?? 0
  }

  private func onSortFilterChange() {
    state.selectedBookIndex = 0
    setupBibleBooks()
    onSelectedBookChange()
  }

  private func onSelectedBookChange() {
    state.selectedChapter = 1
    onSelectedChapterChange()
  }

  private func onSelectedChapterChange() {
    state.selectedStartVerse = 1
    state.selectedEndVerse = 1
    setupChapterVerses()
  }

  private func filterBooks(_ books: [Book]) -> [Book] {
    switch state.selectedTestamentFilter {
    case .all:
      return books
    case .testament(let testament):
      return books.filter { $0.testament == testament }
    }
  }

  private func onSubmit() {
    submitAction(sortedBooks[state.selectedBookIndex].name, state.selectedChapter, state.selectedStartVerse, state.selectedEndVerse)
  }

  var body: some View {
    let passageTextExtra = state.selectedEndVerse > state.selectedStartVerse ? "-\(state.selectedEndVerse)" : ""
    Group {
      if sortedBooks.count > 0 && numberOfChaptersInBook > 0 {
        VStack(spacing: 10) {
          HStack {
            Text("\(sortedBooks[state.selectedBookIndex].name) \(state.selectedChapter):\(state.selectedStartVerse)\(passageTextExtra)")
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
                  .padding([.top, .bottom], 10)
              } else {
                Text("GO")
                  .foregroundColor(.white)
                  .padding([.leading, .trailing], 17)
                  .padding([.top, .bottom], 10)
              }
            }
            .background(Color.blue)
            .cornerRadius(10)
            .disabled(isLoading)
          }
          .padding(.horizontal)


          HStack {
            Picker("Book", selection: $state.selectedBookIndex) {
              ForEach(0..<sortedBooks.count, id: \.self) { index in
                Text(sortedBooks[index].name).tag(index)
              }
            }
            Picker("Chapter", selection: $state.selectedChapter) {
              ForEach(1...numberOfChaptersInBook, id: \.self) { chapter in
                Text("\(chapter)").tag(chapter)
              }
            }
            Picker("Starting Verse", selection: $state.selectedStartVerse) {
              ForEach(1...numberOfVersesInChapter, id: \.self) { verse in
                Text("\(verse)").tag(verse)
              }
            }
            Picker("Ending Verse", selection: $state.selectedEndVerse) {
              ForEach(state.selectedStartVerse...numberOfVersesInChapter, id: \.self) { verse in
                Text("\(verse)").tag(verse)
              }
            }
          }
          .onChange(of: state.selectedBookIndex) {
            // Reset chapter and verse selections when the book changes
            onSelectedBookChange()
          }
          .onChange(of: state.selectedChapter) {
            // Reset verse selections when the chapter changes
            onSelectedChapterChange()
          }
          .pickerStyle(.wheel)
          .frame(height: 200)
          .padding(.top, -30)

          TestamentFilterView(selectedFilter: $state.selectedTestamentFilter)
            .onChange(of: state.selectedTestamentFilter) {
              onSortFilterChange()
            }

          Toggle(isOn: $state.isAlphabeticallySorted) {
            Text("Sort Books Alphabetically")
          }
          .padding(.horizontal)
          .onChange(of: state.isAlphabeticallySorted) {
            onSortFilterChange()
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
  @State var previewState = ScriptureSelectionState()
  return ScriptureSelectorView(
    isLoading: .constant(false),
    state: $previewState,
    submitAction: {_,_,_,_ in }
  )
}

#Preview("Loading") {
  @State var previewState = ScriptureSelectionState(
    selectedBookIndex: 2,
    selectedChapter: 3,
    selectedStartVerse: 1,
    selectedEndVerse: 5,
    isAlphabeticallySorted: true,
    selectedTestamentFilter: .testament(.old)
  )
  return ScriptureSelectorView(
    isLoading: .constant(true),
    state: $previewState,
    submitAction: {_,_,_,_ in }
  )
}
