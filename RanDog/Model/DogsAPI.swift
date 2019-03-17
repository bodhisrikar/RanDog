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
    enum EndPoint {
        case randomImageFromAllDogsCollection
        case randomImageByBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageByBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndPoint = DogsAPI.EndPoint.randomImageByBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndPoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            print(data)
            
            /*do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let url = json["message"] as! String
                print(url)
            } catch let error {
                print(error)
            }*/
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            //print(imageData)
            
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
    
    class func requestAllBreeds(completionHandler: @escaping([String], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let dogBreeds = try decoder.decode(DogBreedsList.self, from: data)
                let dogBreedsNames = dogBreeds.message.keys.map({$0})
                completionHandler(dogBreedsNames, nil)
            } catch let error {
                completionHandler([], error)
            }
            
        }
        task.resume()
    }
}
