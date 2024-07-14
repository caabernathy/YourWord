/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

enum APIError: Error {
  case noInternetConnection
  case invalidURL
  case serverError(String)

  var localizedDescription: String {
    switch self {
    case .noInternetConnection:
      return "You don't have an internet connection so we can't fetch scriptures. Please try again later."
    case .invalidURL:
      return "There was a problem with the request. Please try again later."
    case .serverError(let message):
      return "An error occurred: \(message)"
    }
  }
}

class APIService {
  private let baseURL = URL(string: AppConfig.apiBaseURL)!
  private let networkManager = NetworkManager.shared

  static let shared = APIService()

  private func fetchData<T: Decodable>(from url: URL) async throws -> T {
    guard networkManager.isConnected else {
      throw APIError.noInternetConnection
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw APIError.serverError("Server returned an invalid response.")
    }

    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw APIError.serverError("Failed to process the response: \(error.localizedDescription)")
    }
  }

  func fetchScripture(book: String, chapter: Int, startVerse: Int, endVerse: Int) async throws -> Scripture {
    let endpoint = baseURL.appendingPathComponent("scripture/reference")
    var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
    components.queryItems = [
      URLQueryItem(name: "book", value: book),
      URLQueryItem(name: "chapter", value: String(chapter)),
      URLQueryItem(name: "startVerse", value: String(startVerse)),
      URLQueryItem(name: "endVerse", value: String(endVerse))
    ]

    guard let url = components.url else {
      throw APIError.invalidURL
    }

    return try await fetchData(from: url)
  }

  func searchScriptures(version: BibleVersion, text: String) async throws -> [SearchResultScripture] {
    let endpoint = baseURL.appendingPathComponent("scripture/search")
    var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
    components.queryItems = [
      URLQueryItem(name: "version", value: version.rawValue),
      URLQueryItem(name: "text", value: text)
    ]

    guard let url = components.url else {
      throw APIError.invalidURL
    }

    return try await fetchData(from: url)
  }
}
