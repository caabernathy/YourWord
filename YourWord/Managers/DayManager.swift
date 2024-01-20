/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@Observable class DayManager {
  var currentDayOfWeek = Calendar.current.component(.weekday, from: Date())

  static let shared = DayManager()

  private init() {}

  func updateDay() {
    let newDayOfWeek = Calendar.current.component(.weekday, from: Date())
    if newDayOfWeek != currentDayOfWeek {
      currentDayOfWeek = newDayOfWeek
    }
  }

}
