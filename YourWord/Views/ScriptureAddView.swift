/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureAddView: View {
  var cancelAction: () -> Void
  var addAction: (Scripture) -> Void

  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV

  @State private  var isLoading: Bool = false
  @State private var selectionMode: SelectionMode = .keyword

  @State private var searchText: String = ""
  @State private var hasSearched: Bool = false
  @State private var searchResults: [SearchResultScripture] = []
  @State private var errorMessage: String?

  @State private var selectorState = ScriptureSelectionState()

  @State private var networkManager = NetworkManager.shared

  @State private var showToast = false

  enum SelectionMode: String, CaseIterable {
    case keyword = "Searching Keywords"
    case verse = "Selecting Verses"
  }

  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Spacer()
        if !networkManager.isConnected {
          Text("No internet connection")
            .foregroundColor(.red)
            .padding()
          Spacer()
        }
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
            searchAction: { query in
              Task {
                await performSearch(query)
              }
            }
          )

          if hasSearched {
            ScriptureSearchResultsView(
              allResults: searchResults,
              onResultTap: { scripture in
                Task {
                  await fetchScripture(
                    book: scripture.passage.book,
                    chapter: scripture.passage.chapter,
                    startVerse: scripture.passage.startVerse,
                    endVerse: scripture.passage.endVerse
                  )
                }
              }
            )
          }
        }
        .transition(.opacity)
      case .verse:
        ScriptureSelectorView(
          isLoading: $isLoading,
          state: $selectorState,
          submitAction: { book, chapter, startVerse, endVerse in
            Task {
              await fetchScripture(
                book: book,
                chapter: chapter,
                startVerse: startVerse,
                endVerse: endVerse
              )
            }
          }
        ).transition(.opacity)
      }

      Spacer()
    }
    .padding()
    .toast(isPresented: $showToast, message: errorMessage ?? "")
  }

  private func showErrorMessageToast() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      withAnimation {
        showToast.toggle()
      }
    }
  }

  @MainActor
  private func fetchScripture(book: String, chapter: Int, startVerse: Int, endVerse: Int) async {
    errorMessage = nil
    do {
      isLoading = true
      let scripture = try await APIService.shared.fetchScripture(book: book, chapter: chapter, startVerse: startVerse, endVerse: endVerse)
      addAction(scripture)
    } catch let error as APIError {
      errorMessage = error.localizedDescription
      showErrorMessageToast()
    } catch {
      errorMessage = "An unexpected error occurred. Please try again later."
      showErrorMessageToast()
    }
    isLoading = false
  }

  @MainActor
  private func performSearch(_ query: String) async {
    guard !query.isEmpty else {
      errorMessage = nil
      searchResults = []
      isLoading = false
      hasSearched = false
      return
    }

    errorMessage = nil
    isLoading = true

    do {
      let scriptures  = try await APIService.shared.searchScriptures(version: bibleVersion, text: query)
      searchResults = scriptures
    } catch let error as APIError {
      errorMessage = error.localizedDescription
      searchResults = []
      showErrorMessageToast()
    } catch {
      errorMessage = "An unexpected error occurred. Please try again later."
      searchResults = []
      showErrorMessageToast()
    }
    isLoading = false
    hasSearched = true
  }
}

#Preview {
  let _ = previewContainer
  return ScriptureAddView(
    cancelAction: {},
    addAction: { _ in }
  )
}
