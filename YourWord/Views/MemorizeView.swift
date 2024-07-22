/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SwiftData

struct PageIndexKey: PreferenceKey {
  static var defaultValue: Int = 0
  static func reduce(value: inout Int, nextValue: () -> Int) {
    value = nextValue()
  }
}

struct MemorizeView: View {
  // Access the current color scheme
  @Environment(\.colorScheme) var colorScheme

  var scripture: Scripture
  var isDailyReveal: Bool
  var scriptureViewModel: ScriptureViewModel

  init(scripture: Scripture, isDailyReveal: Bool) {
    self.scripture = scripture
    self.isDailyReveal = isDailyReveal
    self.scriptureViewModel = ScriptureViewModel(scripture: scripture)
  }

  let pageViewCount = 7
  let bibleVersion = SettingsManager.shared.preferredBibleVersion ?? BibleVersion.NIV
  let dailyRevealOverride = SettingsManager.shared.dailyRevealOverride ?? false
  let notificationDayOfWeek = NotificationManager.shared.notificationDayOfWeek
  let currentDayOfWeek = ScheduleManager.shared.currentDayOfWeek

  let colors: [Color] = [.blue, .green, .purple, .brown, .orange]

  @State private var dragOffset: CGFloat = 0
  @State private var pageIndex = 0
  @State private var isSetupDone = false
  @State private var viewBackgroundColor: Color = .clear

  var body: some View {
    let numberOfDaysToShow = isDailyReveal && !dailyRevealOverride ? currentDayOfWeek : pageViewCount
    let _ = scriptureViewModel.mask(for: bibleVersion, days: numberOfDaysToShow)
    GeometryReader { geometry in
      VStack {

        // Content
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 0) {
            ForEach(0..<scriptureViewModel.memoryTexts.count, id: \.self) { index in
              ScriptureView(text: scriptureViewModel.memoryTexts[index], reference: "\(scriptureViewModel.memoryReferences[index]) \(bibleVersion.rawValue)")
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
                pageIndex = min(max(Int(newIndex), 0), scriptureViewModel.memoryTexts.count - 1)
                dragOffset = 0
              }
            }
        )
        .animation(.spring(), value: dragOffset)

        // Pagination
        HStack(spacing: 15) {
          ForEach(0..<scriptureViewModel.memoryTexts.count, id: \.self) { index in
            DayOfWeekButtonView(text: paginationLabel(for: index), isActive: (pageIndex == index)) {
              self.pageChangeAction(newIndex: index)
            }
          }
          ForEach(scriptureViewModel.memoryTexts.count..<pageViewCount, id: \.self) { index in
            DayOfWeekLabelView(text: paginationLabel(for: index))
          }
        }
        .padding(.top, 10)

        Spacer()
          .dynamicHeight(portrait: 116, landscape: 20)
      }
    }
    .background(colorScheme == .dark ? Color.black.opacity(0.3) : .clear)
    .background(colorScheme == .dark ?
                LinearGradient(gradient: Gradient(colors: [viewBackgroundColor, viewBackgroundColor.opacity(0.2)]), startPoint: .top, endPoint: .bottom) :
                  LinearGradient(gradient: Gradient(colors: [Color.white, viewBackgroundColor.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
    // Load the data but don't reset the page index when switching back
    // and forth between tabs
    .onAppear(perform: {
      if isDailyReveal && !isSetupDone {
        pageIndex = currentDayOfWeek - 1
        randomizeGradientColors()
      }
      isSetupDone = true
    })
    // When a new scripture is loaded daily and app is in the Memorize tab
    .onChange(of: currentDayOfWeek) {
      if isDailyReveal {
        let newIndex = currentDayOfWeek - 1
        self.pageChangeAction(newIndex: newIndex)
      }
    }
    .onChange(of: dailyRevealOverride) {
      if isDailyReveal {
        // Change the page view if not showing all days and current page
        // view will no longer be shown
        if !dailyRevealOverride && (pageIndex > currentDayOfWeek - 1) {
          pageIndex = currentDayOfWeek - 1
        }
      }
    }
    // Handle incoming notifications to deep link to the correct day
    .onChange(of: notificationDayOfWeek) {
      if isDailyReveal && (notificationDayOfWeek != nil) {
        if let notificationDayOfWeek = notificationDayOfWeek {
          pageIndex = (notificationDayOfWeek > currentDayOfWeek) ? currentDayOfWeek - 1 : notificationDayOfWeek - 1
          // Reset notification data
          NotificationManager.shared.clearNotificationDat()
        }
      }
    }
    .preference(key: PageIndexKey.self, value: pageIndex)
  }

  private func pageChangeAction(newIndex: Int) {
    withAnimation(.smooth) {
      pageIndex = newIndex
    }
  }

  private func paginationLabel(for index: Int) -> String {
    if !isDailyReveal {
      return "\(index+1)"
    }
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

  private func randomizeGradientColors() {
    viewBackgroundColor = colors.randomElement() ?? Color.blue
  }
}

#Preview("Short Verse") {
  let _ = previewContainer
  return MemorizeView(
    scripture: PreviewData.scriptures[0],
    isDailyReveal: true
  )
  .modelContainer(previewContainer)
}

#Preview("Long Verse") {
  let _ = previewContainer
  return MemorizeView(
    scripture: PreviewData.scriptures[4],
    isDailyReveal: true
  )
  .modelContainer(previewContainer)
}
