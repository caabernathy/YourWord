/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureSelectorView: View {
  // Sample data for Bible books, including chapter and verse counts
  let bibleBooks: [Bible] = [
    Bible(book: "Genesis",
              chaptersAndVerses: [
                1: 31, 2: 25, 3: 24, 4: 26, 5: 32, 6: 22, 7: 24, 8: 22, 9: 29,
                10: 32, 11: 32, 12: 20, 13: 18, 14: 24, 15: 21, 16: 16, 17: 27,
                18: 33, 19: 38, 20: 18, 21: 34, 22: 24, 23: 20, 24: 67, 25: 34,
                26: 35, 27: 46, 28: 22, 29: 35, 30: 43, 31: 55, 32: 32, 33: 20,
                34: 31, 35: 29, 36: 43, 37: 36, 38: 30, 39: 23, 40: 23, 41: 57,
                42: 38, 43: 34, 44: 34, 45: 28, 46: 34, 47: 31, 48: 22, 49: 33,
                50: 26
              ],
              version: .NIV),
    Bible(book: "Exodus",
              chaptersAndVerses: [
                1: 22, 2: 25, 3: 22, 4: 31, 5: 23, 6: 30, 7: 25, 8: 32, 9: 35,
                10: 29, 11: 10, 12: 51, 13: 22, 14: 31, 15: 27, 16: 36, 17: 16,
                18: 27, 19: 25, 20: 26, 21: 36, 22: 31, 23: 33, 24: 18, 25: 40,
                26: 37, 27: 21, 28: 43, 29: 46, 30: 38, 31: 18, 32: 35, 33: 23,
                34: 35, 35: 35, 36: 38, 37: 29, 38: 31, 39: 43, 40: 38
              ],
              version: .NIV),
    Bible(book: "Leviticus",
              chaptersAndVerses: [
                1: 17, 2: 16, 3: 17, 4: 35, 5: 19, 6: 30, 7: 38, 8: 36,
                9: 24, 10: 20, 11: 47, 12: 8, 13: 59, 14: 57, 15: 33,
                16: 34, 17: 16, 18: 30, 19: 37, 20: 27, 21: 24, 22: 33,
                23: 44, 24: 23, 25: 55, 26: 46, 27: 34
              ],
              version: .NIV),
    Bible(book: "Numbers",
              chaptersAndVerses: [
                1: 54, 2: 34, 3: 51, 4: 49, 5: 31, 6: 27, 7: 89, 8: 26,
                9: 23, 10: 36, 11: 35, 12: 16, 13: 33, 14: 45, 15: 41,
                16: 50, 17: 13, 18: 32, 19: 22, 20: 29, 21: 35, 22: 41,
                23: 30, 24: 25, 25: 18, 26: 65, 27: 23, 28: 31, 29: 40,
                30: 16, 31: 54, 32: 42, 33: 56, 34: 29, 35: 34, 36: 13
              ],
              version: .NIV),
    Bible(book: "Deuteronomy",
              chaptersAndVerses: [
                1: 46, 2: 37, 3: 29, 4: 49, 5: 33, 6: 25, 7: 26, 8: 20,
                9: 29, 10: 22, 11: 32, 12: 32, 13: 18, 14: 29, 15: 23,
                16: 22, 17: 20, 18: 22, 19: 21, 20: 20, 21: 23, 22: 30,
                23: 25, 24: 22, 25: 19, 26: 19, 27: 26, 28: 68, 29: 29,
                30: 20, 31: 30, 32: 52, 33: 29, 34: 12
              ],
              version: .NIV),
    Bible(book: "Matthew",
              chaptersAndVerses: [
                1: 25, 2: 23, 3: 17, 4: 25, 5: 48, 6: 34, 7: 29, 8: 34,
                9: 38, 10: 42, 11: 30, 12: 50, 13: 58, 14: 36, 15: 39,
                16: 28, 17: 27, 18: 35, 19: 30, 20: 34, 21: 46, 22: 46,
                23: 39, 24: 51, 25: 46, 26: 75, 27: 66, 28: 20
              ],
              version: .NIV),
    Bible(book: "Mark",
              chaptersAndVerses: [
                1: 45, 2: 28, 3: 35, 4: 41, 5: 43, 6: 56, 7: 37, 8: 38,
                9: 50, 10: 52, 11: 33, 12: 44, 13: 37, 14: 72, 15: 47,
                16: 20
              ],
              version: .NIV),
    Bible(book: "Luke",
              chaptersAndVerses: [
                1: 80, 2: 52, 3: 38, 4: 44, 5: 39, 6: 49, 7: 50, 8: 56,
                9: 62, 10: 42, 11: 54, 12: 59, 13: 35, 14: 35, 15: 32,
                16: 31, 17: 37, 18: 43, 19: 48, 20: 47, 21: 38, 22: 71,
                23: 56, 24: 53
              ],
              version: .NIV),
    Bible(book: "John",
              chaptersAndVerses: [
                1: 51, 2: 25, 3: 36, 4: 54, 5: 47, 6: 71, 7: 53, 8: 59,
                9: 41, 10: 42, 11: 57, 12: 50, 13: 38, 14: 31, 15: 27,
                16: 33, 17: 26, 18: 40, 19: 42, 20: 31, 21: 25
              ],
              version: .NIV),
    Bible(book: "Acts",
              chaptersAndVerses: [
                1: 26, 2: 47, 3: 26, 4: 37, 5: 42, 6: 15, 7: 60, 8: 40,
                9: 43, 10: 48, 11: 30, 12: 25, 13: 52, 14: 28, 15: 41,
                16: 40, 17: 34, 18: 28, 19: 41, 20: 38, 21: 40, 22: 30,
                23: 35, 24: 27, 25: 27, 26: 32, 27: 44, 28: 31
              ],
              version: .NIV),
    Bible(book: "Romans",
              chaptersAndVerses: [
                1: 32, 2: 29, 3: 31, 4: 25, 5: 21, 6: 23, 7: 25, 8: 39,
                9: 33, 10: 21, 11: 36, 12: 21, 13: 14, 14: 23, 15: 33,
                16: 27
              ],
              version: .NIV),
  ]

  @State private var selectedBookIndex = 0
  @State private var selectedChapter = 1
  @State private var selectedStartingVerse = 1
  @State private var selectedEndingVerse = 1
  @State private var isAlphabeticallySorted = false

  var sortedBooks: [Bible] {
    isAlphabeticallySorted ? bibleBooks.sorted() : bibleBooks
  }

  private func numberOfVersesInChapter() -> Int {
    let book = sortedBooks[selectedBookIndex]
    return book.chaptersAndVerses[selectedChapter] ?? 0
  }

  var body: some View {
    VStack {
      HStack {
        Picker("Book", selection: $selectedBookIndex) {
          ForEach(0..<sortedBooks.count, id: \.self) { index in
            Text(self.sortedBooks[index].book).tag(index)
          }
        }

        Picker("Chapter", selection: $selectedChapter) {
          ForEach(1...sortedBooks[selectedBookIndex].numberOfChapters, id: \.self) { chapter in
            Text("\(chapter)").tag(chapter)
          }
        }
        .onChange(of: selectedBookIndex) {
          // Reset chapter and verse selections when the book changes
          selectedChapter = 1
          selectedStartingVerse = 1
          selectedEndingVerse = 1
        }

        Picker("Starting Verse", selection: $selectedStartingVerse) {
          ForEach(1...numberOfVersesInChapter(), id: \.self) { verse in
            Text("\(verse)").tag(verse)
          }
        }
        .onChange(of: selectedChapter) {
          // Reset verse selections when the chapter changes
          selectedStartingVerse = 1
          selectedEndingVerse = 1
        }

        Picker("Ending Verse", selection: $selectedEndingVerse) {
          ForEach(selectedStartingVerse...numberOfVersesInChapter(), id: \.self) { verse in
            Text("\(verse)").tag(verse)
          }
        }
      }
      .pickerStyle(.wheel)

      Toggle(isOn: $isAlphabeticallySorted) {
        Text("Sort Books Alphabetically")
      }
      .padding()
    }
  }
}


#Preview {
  ScriptureSelectorView()
}
