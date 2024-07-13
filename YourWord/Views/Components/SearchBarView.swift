/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct SearchBarView: View {
  @Binding var isLoading: Bool
  var searchAction: (String) -> Void

  @State private var searchText: String = ""
  
  var body: some View {
    HStack {
      TextField("Enter passage, keyword...", text: $searchText)
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)

      Button(action: {
        if !isLoading {
          searchAction(searchText)
        }
      }) {
        Group {
          if isLoading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
          } else {
            Image(systemName: "magnifyingglass")
          }
        }
        .frame(width: 20, height: 20)
        .foregroundColor(.white)
      }
      .frame(width: 44, height: 44)
      .background(Color.blue)
      .cornerRadius(8)
      .disabled(isLoading)
    }
    .padding()
  }
}

#Preview("Default") {
  SearchBarView(
    isLoading: .constant(false),
    searchAction: {_ in }
  )
}

#Preview("Searching") {
  SearchBarView(
    isLoading: .constant(true),
    searchAction: {_ in }
  )
}
