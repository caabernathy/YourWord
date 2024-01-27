/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@Observable class OnboardingManager {
  enum OnboardingConstants {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
  }

  var hasCompletedOnboarding: Bool

  init() {
    hasCompletedOnboarding = UserDefaults.standard.object(forKey: OnboardingConstants.hasCompletedOnboarding) as? Bool ?? false
  }

  func completeOnboarding() {
    self.hasCompletedOnboarding = true
    UserDefaults.standard.set(true, forKey: OnboardingConstants.hasCompletedOnboarding)
  }
}
