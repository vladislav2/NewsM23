//
//  NetworkDataFetcher.swift
//  TXiBPcod
//
//  Created by user on 04.01.2021.
//

import Foundation

class NetworkDataFetcher {
  
  var networkService = NetworkService()
  
  func fetchNews(country: String, category: String, searchTerm: String, page: Int, completion: @escaping (NewsResponse?) -> ()) {
    networkService.request(country: country, category: category, searchTerm: searchTerm, page: page) { (data, error) in
      if let error = error {
        print("Error received requesting data: \(error.localizedDescription)")
        completion(nil)
      }
      
      let decode = self.decodeJSON(type: NewsResponse.self, from: data)
      completion(decode)
    }
  }
  
  func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
    let decoder = JSONDecoder()
    guard let data = from else { return nil }
    
    do {
      let objects = try decoder.decode(type.self, from: data)
      return objects
    } catch let jsonError {
      print("Failed to decode JSON", jsonError)
      return nil
    }
  }
}
