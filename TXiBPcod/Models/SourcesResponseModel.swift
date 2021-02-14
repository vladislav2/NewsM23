//
//  SourcesResponseModel.swift
//  TXiBPcod
//
//  Created by user on 12.02.2021.
//

import Foundation

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}
