//
//  ItemModel.swift
//  ImgurSearchClient
//
//  Created by Laxman Penmesta on 6/27/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit

class ItemModel{
    var imageLink: String
    var title: String
    
    init(_ imageLink: String, _ title: String) {
        self.imageLink = imageLink
        self.title = title
    }
}
