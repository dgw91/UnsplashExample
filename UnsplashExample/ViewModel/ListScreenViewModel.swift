//
//  ListScreenViewModel.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import Foundation

// As apps evolve we may want to make view models conform to a protocol to help keep their usage in line with what they are meant to do
class ListScreenViewModel {
    var currentPage: Int = 0 
    let unsplashService = UnsplashService()
    var results: [SearchResult] = []
    
    func searchPictures(query: String, page: Int? = nil, completion: @escaping ((_ data: SearchResponse?,_ error: Error?) -> Void)) {
        // Ideally the APIs would be designed to return observable properties that would make the data flow through the app a little easier.
        // It's not needed here since there is very little information that has to be updated, but it would be nice
        // The result of not using RxSwift however is that I am abusing completion handlers a bit at this point
        unsplashService.searchImages(query: query, page: page, perPage: 30 ) { data, error in
            completion(data, error)
        }
    }
}
