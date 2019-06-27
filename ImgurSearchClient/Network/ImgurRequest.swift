//
//  ImgurRequest.swift
//  ImgurSearchClient
//
//  Created by Laxman Penmesta on 6/27/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation

struct ImgurRequest {
    let baseUrlString: String
    var pageNumber: Int
    let searchParameter: String
    var searchQuery: String
    var urlString: String
    
    init(_ pageNumber: Int, _ searchParameter: String) {
        self.baseUrlString = Constants.baseURL
        self.pageNumber = pageNumber
        self.searchParameter = searchParameter
        self.searchQuery = "?q=\(searchParameter)"
        self.urlString = self.baseUrlString + String(self.pageNumber) + self.searchQuery
    }
}
