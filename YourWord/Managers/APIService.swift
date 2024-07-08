/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class APIService {
  private let baseURL = URL(string: AppConfig.apiBaseURL)!

  static let shared = APIService()

  func fetchScripture(book: String, chapter: Int, startVerse: Int, endVerse: Int, completion: @escaping (Result<Scripture, Error>) -> Void) {
    let endpoint = baseURL.appendingPathComponent("scripture/reference")
    var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
    components.queryItems = [
      URLQueryItem(name: "book", value: book),
      URLQueryItem(name: "chapter", value: String(chapter)),
      URLQueryItem(name: "startVerse", value: String(startVerse)),
      URLQueryItem(name: "endVerse", value: String(endVerse))
    ]

    guard let url = components.url else {
      completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
      return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        do {
          let scripture = try JSONDecoder().decode(Scripture.self, from: data)
          completion(.success(scripture))
        } catch {
          completion(.failure(error))
        }
      } else if let error = error {
        completion(.failure(error))
      }
    }.resume()
  }
}
