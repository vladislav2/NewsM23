//
//  ArticleModel.swift
//  TXiBPcod
//
//  Created by user on 12.02.2021.
//

import Foundation

struct Article: Codable {
  let title: String
  let description: String?
  let author: String?
  let source: ArticleSource?
  let urlToImage: String?
  let publishedAt: String?
  let url: String?
  //let source: Source
}
