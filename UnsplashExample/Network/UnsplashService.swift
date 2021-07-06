//
//  UnsplashService.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import Foundation

class UnsplashService {
    
    // Ideally these calls would be a swagger generated list of availble apis from a back end that could just be passed parameters
    public func searchImages(query: String, page: Int? = nil, perPage: Int? = nil, sortedBy: Sorted = .relevant, completion: @escaping ((_ data: SearchResponse?,_ error: Error?) -> Void)) {
        let queryItems: [URLQueryItem] = [
            // Gracefully handle spaces.
            URLQueryItem(name: "query", value: query.replacingOccurrences(of: " ", with: "-")),
            URLQueryItem(name: "page", value: page?.description),
            URLQueryItem(name: "per_page", value: perPage?.description),
            URLQueryItem(name: "ordered_by", value: sortedBy.rawValue),
            URLQueryItem(name: "client_id", value: NetworkConstants.AccessKey)
         ]
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = NetworkConstants.Domain
            components.path = NetworkConstants.Route
            components.queryItems = queryItems
            return components.url
        }
        // In a larger application a lot of the following logic could be wrapped in a networking libray such as alamofire, but it's not too bad to write out ourselves
        guard let url = url else {
            return
        }
        
        let urlTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                 return
            }
            do {
                let json = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(json,error)
            }
            catch {
                // Ideally there would be a robust error system that tell the user what went wrong and/or send some logs to a place for us to monitor here. For now I'm just going to print the error.
                print(error)
            }
        }
        urlTask.resume()
    }
}
