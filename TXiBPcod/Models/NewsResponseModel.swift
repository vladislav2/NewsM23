//
//  NewsResponseModel.swift
//  TXiBPcod
//
//  Created by user on 12.02.2021.
//

import Foundation

struct NewsResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}
