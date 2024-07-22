/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScriptureSearchResultsView: View {
  let allResults: [SearchResultScripture]
  let onResultTap: (SearchResultScripture) -> Void

  @State private var displayedResults: [SearchResultScripture] = []
  @State private var currentPage: Int = 1
  @State private var tappedResultId: UUID?
  private let resultsPerPage: Int = 10

  var body: some View {
    VStack(spacing: 0) {
      if allResults.isEmpty {
        Text("No results found")
          .foregroundColor(.gray)
          .padding()
      } else {
        Text("Hint: Tap to select a verse")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
          .background(Color(.systemBackground))

        List {
          ForEach(displayedResults) { result in
            ScriptureRowView(scripture: result, isTapped: tappedResultId == result.id)
              .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                  tappedResultId = result.id
                }
                onResultTap(result)

                // Reset the tapped state after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  withAnimation(.easeInOut(duration: 0.3)) {
                    tappedResultId = nil
                  }
                }
              }
              .listRowInsets(EdgeInsets())
          }
          if hasMoreResults {
            ProgressView()
              .onAppear {
                loadMoreResults()
              }
          }
        }
        .listStyle(PlainListStyle())
        .environment(\.defaultMinListRowHeight, 0)
      }
    }
    .onAppear {
      loadMoreResults()
    }
  }

  private var hasMoreResults: Bool {
    displayedResults.count < allResults.count
  }

  private func loadMoreResults() {
    let startIndex = (currentPage - 1) * resultsPerPage
    let endIndex = min(startIndex + resultsPerPage, allResults.count)

    guard startIndex < endIndex else {
      // This guard prevents the range error
      return
    }

    let newResults = Array(allResults[startIndex..<endIndex])
    displayedResults.append(contentsOf: newResults)
    currentPage += 1
  }
}

#Preview {
  let _ = previewContainer
  let scriptures = PreviewData.searchResultScriptures
  return ScriptureSearchResultsView(
    allResults: scriptures,
    onResultTap: { _ in }
  )
}
