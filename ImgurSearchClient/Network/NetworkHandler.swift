//
//  NetworkHandler.swift
//  ImgurSearchClient
//
//  Created by Laxman Penmesta on 6/27/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation

class NetworkHandler{
    func fetchImagesBySearch(_ page: Int, _ searchTem: String, completion: @escaping ([ItemModel]) -> Void){
        guard let url = URL(string: ImgurRequest.init(page, searchTem).urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(Constants.clientID)", forHTTPHeaderField: Constants.Authorization)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            var itemsArr = [ItemModel]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let result = json as? [String: Any], let dataArray = result["data"] as? [[String: Any]] {
                    for data in dataArray {
                        if let images = data["images"] as? [[String: Any]], let imageLink = images[0]["link"] as? String, let title = data["title"] as? String {
                            itemsArr.append(ItemModel(imageLink, title))
                        }
                    }
                }
            } catch (let error) {
                print("WebService request failed with: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(itemsArr)
            }
            
            }.resume()
    }
}
