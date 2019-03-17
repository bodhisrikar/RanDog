//
//  DogBreedsList.swift
//  RanDog
//
//  Created by Srikar Thottempudi on 3/17/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import Foundation

struct DogBreedsList: Codable {
    let status: String
    let message: [String : [String]]
}
