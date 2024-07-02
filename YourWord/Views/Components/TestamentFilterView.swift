/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

enum TestamentFilter: Hashable {
  case all
  case testament(Testament)

  var displayName: String {
    switch self {
    case .all:
      return "All"
    case .testament(let testament):
      return testament.rawValue.capitalized + " Testament"
    }
  }

  static var allCases: [TestamentFilter] {
    [.all] + Testament.allCases.map { .testament($0) }
  }
}

struct TestamentFilterView: View {
  @Binding var selectedFilter: TestamentFilter

  var body: some View {
    Picker("Testament", selection: $selectedFilter) {
      ForEach(TestamentFilter.allCases, id: \.self) { filter in
        Text(filter.displayName).tag(filter)
      }
    }
    .pickerStyle(SegmentedPickerStyle())
    .padding()
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var selectedFilter: TestamentFilter = .all

    var body: some View {
      TestamentFilterView(selectedFilter: $selectedFilter)
    }
  }

  return PreviewWrapper()
}
