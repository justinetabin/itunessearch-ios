//
//  iTunesStoreApi.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/29/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class iTunesStoreApi: StoreApi {
    var httpClient: HTTPClient
    
    init(baseUrl: String) {
        httpClient = HTTPClient(baseUrl: baseUrl)
    }
    
    func search(query: SearchQuery, completion: @escaping (StoreResult<[Movie]>?, Error?) -> Void) {
        let request = HTTPClient.Request(path: "/search?term=\(query.term)&media=\(query.media)&country=\(query.country)", method: .GET)
        httpClient.dataTask(type: StoreResult.self, request: request) { (response) in
            completion(response.body, response.error)
        }
    }
    
    func lookup(query: LookupQuery, completion: @escaping (StoreResult<[Movie]>?, Error?) -> Void) {
        let request = HTTPClient.Request(path: "/lookup?id=\(query.id)", method: .GET)
        httpClient.dataTask(type: StoreResult.self, request: request) { (response) in
            completion(response.body, response.error)
        }
    }
}
