//
//  TableViewCell.swift
//  TXiBPcod
//
//  Created by user on 30.12.2020.
//

import UIKit

class TableViewCell: UITableViewCell {

  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var sourceLabel: UILabel!
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var newsImage: UIImageView!
  @IBOutlet private weak var descriptionLabel: UILabel!
  
  func setData(data: Any?) {
    if let article = data as? Article {
      titleLabel.text = article.title
      sourceLabel.text = article.source?.name
      authorLabel.text = article.author
      descriptionLabel.text = article.description
      if let urlToImg = URL(string: article.urlToImage ?? "") {
        newsImage.load(url: urlToImg)
      }
    }
  }
}

