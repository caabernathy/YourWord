/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct OnboardingView: View {
  @Environment(OnboardingManager.self) private var onboardingManager

  let carouselData = [
    (image: "logo", title: "Welcome to Your Word", description: "Memorize a new Bible verse each week using a simple technique."),
    (image: "memorize", title: "Memorize", description: "Every day you fill in the blanks to help you memorize the Scripture."),
    (image: "add-custom", title: "Add Your Own", description: "You can select and add Scriptures you want to memorize."),
    (image: "review", title: "Review", description: "You can view past Scriptures to continue meditating on God's word.")
  ]

  @State private var selection = 0

  var body: some View {
    TabView(selection: $selection) {
      ForEach(0..<carouselData.count, id: \.self) { index in
        VStack {
          Image(carouselData[index].image)
            .resizable()
            .scaledToFit()

          Text(carouselData[index].title)
            .font(.title)
            .padding(.top, 20)

          Text(carouselData[index].description)
            .font(.body)
            .padding(.top, 10)
            .padding(.leading, 10)
            .padding(.trailing, 10)

          if index == carouselData.count - 1 {
            Button(action: {
              onboardingManager.completeOnboarding()
            }) {
              Text("Get Started")
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
            }
            .padding(.bottom, 10)
          } else {
            Spacer()
              .frame(height: 40)
          }
        }
        .padding()
        .tag(index)
      }
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
  }
}

#Preview {
  OnboardingView()
    .environment(OnboardingManager())
}
