/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct AppConfig {
  static let apiBaseURL: String = {
    guard let apiBaseURL = Bundle.main.infoDictionary?["API_BASE_URL"] as? String else {
      fatalError("API_BASE_URL not set in plist")
    }
    return apiBaseURL
  }()
}
