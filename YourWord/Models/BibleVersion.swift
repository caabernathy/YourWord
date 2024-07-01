/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

enum BibleVersion: String, Codable, CaseIterable, Identifiable {
  case NIV
  case ESV
  case NLT
  case KJV

  var id: Self { self }
}
