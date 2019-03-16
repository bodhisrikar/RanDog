//
//  ViewController.swift
//  RanDog
//
//  Created by Srikar Thottempudi on 3/14/19.
//  Copyright © 2019 Srikar Thottempudi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DogsAPI.requestRandomImage(completionHandler: self.downloadImageURL(imageData:error:))
    }

    func downloadImageURL(imageData: DogImage?, error: Error?) {
        guard let imageURL = URL(string: imageData!.message) else {
            return
        }
        DogsAPI.requestImage(url: imageURL, completionHandler: self.handleImageLoading(image:error:))
    }

    func handleImageLoading(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.loadImage.image = image
        }
    }

}

