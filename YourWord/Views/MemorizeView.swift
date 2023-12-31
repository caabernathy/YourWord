/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SwiftData

struct MemorizeView: View {
  var scripture: Scripture
  var isDailyReveal: Bool

  let pageViewCount = 7
  let bibleTranslation = SettingsManager.shared.preferredBibleTranslation ?? BibleTranslation.NIV
  let dailyRevealOverride = SettingsManager.shared.dailyRevealOverride ?? false

  @EnvironmentObject var appDelegate: AppDelegate
  @State private var dragOffset: CGFloat = 0
  @State private var pageIndex = 0
  @State private var memoryTexts: [String] = []
  @State private var memorySources: [String] = []

  var body: some View {
    GeometryReader { geometry in
      VStack {

        // Content
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 0) {
            ForEach(0..<memoryTexts.count, id: \.self) { index in
              ScriptureView(text: memoryTexts[index], source: "\(memorySources[index]) \(bibleTranslation.rawValue)")
                .padding()
                .frame(width: geometry.size.width)
            }
          }
        }
        .content.offset(x: (CGFloat(pageIndex) * -geometry.size.width) + dragOffset)
        .frame(width: geometry.size.width, alignment: .leading)
        .gesture(
          DragGesture().onChanged { value in
            dragOffset = value.translation.width
          }
            .onEnded { value in
              withAnimation(.smooth) {
                let offset = value.translation.width
                let newIndex = (CGFloat(pageIndex) - (offset / geometry.size.width)).rounded()
                pageIndex = min(max(Int(newIndex), 0), memoryTexts.count - 1)
                dragOffset = 0
              }
            }
        )
        .animation(.spring(), value: dragOffset)

        // Pagination
        HStack(spacing: 15) {
          ForEach(0..<memoryTexts.count, id: \.self) { index in
            DayOfWeekButtonView(text: paginationLabel(for: index), isActive: (pageIndex == index)) {
              self.pageChangeAction(newIndex: index)
            }
          }
          ForEach(memoryTexts.count..<pageViewCount, id: \.self) { index in
            DayOfWeekLabelView(text: paginationLabel(for: index))
          }
        }
        .padding(.top, 10)

        if isDailyReveal && pageIndex == (pageViewCount - 1) {
          DoneButtonView() {
            markMemorizationAsCompleted()
          }
          .padding(.top, 20)
        } else {
          Spacer()
            .frame(height: 116)
        }

        Spacer()
      }
    }
    .onAppear(perform: {
      loadMemorizeData()
    })
  }

  private func pageChangeAction(newIndex: Int) {
    withAnimation(.smooth) {
      pageIndex = newIndex
    }
  }

  private func loadMemorizeData() {
    guard
      let scriptureText = scripture.translation(for: bibleTranslation) else { return }
    let maskedTexts = ScriptureManager.shared.maskScriptureText(scriptureText)
    let maskedSources = ScriptureManager.shared.maskSriptureReference(scripture.passage)
    let dayOfWeek = isDailyReveal ? Calendar.current.component(.weekday, from: Date()) : pageViewCount
    // Set up the starting point based on...
    // Is it the daily memorization view?
    if isDailyReveal {
      // notification not nil && data <= dayOfWeek
      // Was this opened due to a notification event?
      if let notificationData = appDelegate.notificationData {
        pageIndex = (notificationData > dayOfWeek) ? dayOfWeek - 1 : notificationData - 1
        // Reset notification data
        appDelegate.notificationData = nil
      } else {
        // Start at the day of the week
        pageIndex = dayOfWeek - 1
      }
    } else {
      // If part of the saved verses view, start at 0
      pageIndex = 0
    }
    // Work out how many day's worth or memorizations to show
    let numberOfDaysToShow = isDailyReveal && !dailyRevealOverride ? dayOfWeek : pageViewCount
    memoryTexts = Array(maskedTexts.prefix(numberOfDaysToShow))
    memorySources = Array(maskedSources.prefix(numberOfDaysToShow))
  }

  private func markMemorizationAsCompleted() {
    scripture.completed = true
  }

  private func paginationLabel(for index: Int) -> String {
    switch index {
    case 0:
      return "S" // Sunday
    case 1:
      return "M" // Monday
    case 2:
      return "T" // Tuesday
    case 3:
      return "W" // Wednesday
    case 4:
      return "T" // Thursday
    case 5:
      return "F" // Friday
    case 6:
      return "S" // Saturday
    default:
      return "X" // For indices not between 0 and 6
    }
  }
}
