//
//  DogsAPI.swift
//  RanDog
//
//  Created by Srikar Thottempudi on 3/14/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation
import UIKit

class DogsAPI {
    enum EndPoint: String {
        case randomImageFromAllDogsCollection = "https://dog.ceo/api/breeds/image/random"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndPoint = DogsAPI.EndPoint.randomImageFromAllDogsCollection.url
        let task = URLSession.shared.dataTask(with: randomImageEndPoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let url = json["message"] as! String
                print(url)
            } catch let error {
                print(error)
            }
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            print(imageData)
            
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    class func requestImage(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let image = UIImage(data: data)
            completionHandler(image, nil)
        })
        task.resume()
    }
}
