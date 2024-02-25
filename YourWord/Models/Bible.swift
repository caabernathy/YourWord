/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct Bible: Identifiable, Comparable {
  let id = UUID()
  var book: String
  // An array representing each chapter and its number of verses
  var chaptersAndVerses: [Int: Int]
  var version: BibleVersion

  var numberOfChapters: Int {
    chaptersAndVerses.count
  }
  
  // Implement Comparable for sorting
  static func < (lhs: Bible, rhs: Bible) -> Bool {
    return lhs.book < rhs.book
  }
}
