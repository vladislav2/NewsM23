//
//  NetworkService.swift
//  TXiBPcod
//
//  Created by user on 31.12.2020.
//

import Foundation

class NetworkService {
  
  func request(country: String, category: String, searchTerm: String, page: Int, completion: @escaping (Data?, Error?) -> Void) {
    let prepareParameters = self.prepareParameters(country: country, category: category, searchTerm: searchTerm, page: page)
    let url = self.url(params: prepareParameters)
    print(url)
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = prepareHeader()
    request.httpMethod = "get"
    let task = createDataTask(from: request, completion: completion)
    task.resume()
  }
  
  private func prepareHeader() -> [String: String]? {
      var headers = [String: String]()
    headers["Authorization"] = "483c4f0fa9494bda8462616a00863f53"
      return headers
  }
  
  private func prepareParameters(country: String?, category: String?, searchTerm: String?, page: Int) -> [String: String] {
      var parameters = [String: String]()
      parameters["q"] = searchTerm
      parameters["category"] = category
      parameters["country"] = country
      parameters["pageSize"] = String(20)
      parameters["page"] = String(page)
      return parameters
  }
  
  private func url (params: [String: String]) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "newsapi.org"
    components.path = "/v2/top-headlines"
    components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
    return components.url!
  }
  
  private func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
      return URLSession.shared.dataTask(with: request) { (data, response, error) in
          DispatchQueue.main.async {
              completion(data, error)
          }
      }
  }
}
