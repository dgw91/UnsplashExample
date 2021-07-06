//
//  SearchResponse.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import Foundation

struct SearchResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [SearchResult]
}

