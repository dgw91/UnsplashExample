//
//  SearchResult.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import Foundation

struct SearchResult: Codable {
    let id: String
    let description: String?
    let tags: [Tag]?
    let urls: UnsplashURL
    let user: User
}
