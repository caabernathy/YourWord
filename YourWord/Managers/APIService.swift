/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class APIService {
  static let shared = APIService()

  func fetchScripture(book: String, chapter: Int, startVerse: Int, endVerse: Int, completion: @escaping (Result<Scripture, Error>) -> Void) {
    let url = URL(string: "http://localhost:3000/scripture/reference?book=\(book)&chapter=\(chapter)&startVerse=\(startVerse)&endVerse=\(endVerse)")!

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
