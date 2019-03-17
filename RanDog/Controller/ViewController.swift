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
    @IBOutlet weak var dogPickerView: UIPickerView!
    
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dogPickerView.delegate = self
        dogPickerView.dataSource = self
        
        DogsAPI.requestAllBreeds(completionHandler: handleAllBreeds(names:error:))
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
    
    func handleAllBreeds(names: [String], error: Error?) {
        breeds = names
        DispatchQueue.main.async {
            self.dogPickerView.reloadAllComponents()
        }
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogsAPI.requestRandomImage(breed: breeds[row], completionHandler: self.downloadImageURL(imageData:error:))
    }
}

