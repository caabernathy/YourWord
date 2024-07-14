/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureAddView: View {
  @Binding var isLoading: Bool
  var cancelAction: () -> Void
  var submitAction: (String, Int, Int, Int) -> Void

  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV

  @State private var selectionMode: SelectionMode = .keyword

  @State private var searchText: String = ""
  @State private var hasSearched: Bool = false
  @State private var searchResults: [SearchResultScripture] = []
  @State private var errorMessage: String?

  @State private var selectorState = ScriptureSelectionState()

  enum SelectionMode: String, CaseIterable {
    case keyword = "Searching Keywords"
    case verse = "Selecting Verses"
  }

  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Spacer()
        Button(action: cancelAction) {
          Image(systemName: "xmark")
            .foregroundColor(.gray)
            .padding()
        }
      }

      VStack(alignment: .center, spacing: 10) {
        Text("Find By")
          .font(.headline)

        Picker("Selection Mode", selection: $selectionMode) {
          ForEach(SelectionMode.allCases, id: \.self) { mode in
            Text(mode.rawValue).tag(mode)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      .padding([.bottom], 20)
      .padding(.horizontal)

      switch selectionMode {
      case .keyword:
        VStack {
          SearchBarView(
            isLoading: $isLoading,
            searchText: $searchText,
            searchAction: performSearch
          )

          if let errorMessage = errorMessage {
            Text(errorMessage)
              .foregroundColor(.red)
              .padding()
          } else if hasSearched {
            ScriptureSearchResultsView(
              allResults: searchResults,
              onResultTap: { scripture in
                submitAction(
                  scripture.passage.book,
                  scripture.passage.chapter,
                  scripture.passage.startVerse,
                  scripture.passage.endVerse
                )
              }
            )
          }
        }
        .transition(.opacity)
      case .verse:
        ScriptureSelectorView(
          isLoading: $isLoading,
          state: $selectorState,
          submitAction: submitAction
        ).transition(.opacity)
      }

      Spacer()
    }
    .padding()
  }

  private func performSearch(_ query: String) {
    guard !query.isEmpty else {
      searchResults = []
      errorMessage = nil
      isLoading = false
      hasSearched = false
      return
    }

    isLoading = true
    errorMessage = nil

    APIService.shared.searchScriptures(version: bibleVersion, text: query) { result in
      DispatchQueue.main.async {
        self.isLoading = false
        self.hasSearched = true

        switch result {
        case .success(let scriptures):
          self.searchResults = scriptures
          self.errorMessage = nil
        case .failure(let error):
          self.searchResults = []
          self.errorMessage = "An error occurred while searching: \(error.localizedDescription)"
        }
      }
    }
  }
}

#Preview {
  let _ = previewContainer
  return ScriptureAddView(
    isLoading: .constant(false),
    cancelAction: {},
    submitAction: {_,_,_,_ in }
  )
}
