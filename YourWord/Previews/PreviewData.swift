/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct PreviewData {
  static let scriptures: [Scripture] = [
    Scripture(
      passage: Passage(book: "Genesis", chapter: 1, startVerse: 1, endVerse: 1),
      translations: [
        Translation(name: .NIV, text: "In the beginning God created the heavens and the earth."),
      ],
      source: .system),
    Scripture(
      passage: Passage(book: "Deuteronomy", chapter: 4, startVerse: 4, endVerse: 4),
      translations: [
        Translation(name: .NIV, text: "Hear, O Israel: The LORD our God, the LORD is one."),
      ],
      source: .system),
    Scripture(
      passage: Passage(book: "John", chapter: 1, startVerse: 1, endVerse: 1),
      translations: [
        Translation(name: .NIV, text: "In the beginning was the Word, and the Word was with God, and the Word was God."),
      ],
      source: .userDefined),
  ]

  static let bibleComposition: [BibleComposition] = [
    BibleComposition(
      id: "uuid-genesis",
      name: "Genesis",
      chaptersAndVerses:
        [
          1: 31, 2: 25, 3: 24, 4: 26, 5: 32, 6: 22, 7: 24, 8: 22, 9: 29,
          10: 32, 11: 32, 12: 20, 13: 18, 14: 24, 15: 21, 16: 16, 17: 27,
          18: 33, 19: 38, 20: 18, 21: 34, 22: 24, 23: 20, 24: 67, 25: 34,
          26: 35, 27: 46, 28: 22, 29: 35, 30: 43, 31: 55, 32: 32, 33: 20,
          34: 31, 35: 29, 36: 43, 37: 36, 38: 30, 39: 23, 40: 23, 41: 57,
          42: 38, 43: 34, 44: 34, 45: 28, 46: 34, 47: 31, 48: 22, 49: 33,
          50: 26
        ]),
    BibleComposition(
      id: "uuid-acts",
      name: "Acts",
      chaptersAndVerses:
        [
          1: 26, 2: 47, 3: 26, 4: 37, 5: 42, 6: 15, 7: 60, 8: 40,
          9: 43, 10: 48, 11: 30, 12: 25, 13: 52, 14: 28, 15: 41,
          16: 40, 17: 34, 18: 28, 19: 41, 20: 38, 21: 40, 22: 30,
          23: 35, 24: 27, 25: 27, 26: 32, 27: 44, 28: 31
        ]),
    BibleComposition(
      id: "uuid-romans",
      name: "Romans",
      chaptersAndVerses:
        [
          1: 32, 2: 29, 3: 31, 4: 25, 5: 21, 6: 23, 7: 25, 8: 39,
          9: 33, 10: 21, 11: 36, 12: 21, 13: 14, 14: 23, 15: 33,
          16: 27
        ]),
  ]

  static let bible: [Bible] = [
    Bible(compositionId: "uuid-genesis", bookOrder: 1, version: .NIV),
    Bible(compositionId: "uuid-acts", bookOrder: 20, version: .NIV),
    Bible(compositionId: "uuid-romans", bookOrder: 30, version: .NIV)
  ]
}
