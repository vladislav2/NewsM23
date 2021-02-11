//
//  NewsModel.swift
//  TXiBPcod
//
//  Created by user on 31.12.2020.
//

import Foundation

struct NewsResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
    let author: String?
    let urlToImage: String?
    let publishedAt: String?
    let url: String?
    //let source: Source
}

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}

struct Source: Codable {
    let id: String?
    let name: String?
    let description: String?
    let country: String?
    let category: String?
    let url: String?
}
