//
//  ViewController.swift
//  PhotoAlbum
//
//  Created by Görkem Altunay on 18/04/2017.
//  Copyright © 2017 Görkem Altunay. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    // outlets and variables
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var copyPhotoButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var photosArray : Array<UIImage> = [] ;
    var currentIndex : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.fetchPhotos()
        secondImageView.image = UIImage(named:"placeholder")
        firstButton.setTitleColor(UIColor.gray, for: .disabled)
        nextButton.setTitleColor(UIColor.gray, for: .disabled)
        previousButton.setTitleColor(UIColor.gray, for: .disabled)
        lastButton.setTitleColor(UIColor.gray, for: .disabled)
        deleteButton.setTitleColor(UIColor.gray, for: .disabled)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchPhotos() {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                let imgManager = PHImageManager.default()
                
                // Note that if the request is not set to synchronous
                // the requestImageForAsset will return both the image
                // and thumbnail; by setting synchronous to true it
                // will return just the thumbnail
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                
                // Sort the images by creation date
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                print("Found \(allPhotos.count) images")
                // If the fetch result isn't empty,
                // proceed with the image request
                if allPhotos.count > 0 {
                    for index in 0...allPhotos.count-1
                    {
                        imgManager.requestImage(for: allPhotos.object(at:index) as PHAsset, targetSize: CGSize(width: 200, height: 200) , contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                            self.photosArray.append(image!)
                            if self.photosArray.count == allPhotos.count {
                                self.performSelector(onMainThread: #selector(ViewController.initiateGallery), with: nil, waitUntilDone: false);
                            }
                        })
                    }
                } else {
                    self.performSelector(onMainThread: #selector(ViewController.initiateGallery), with: nil, waitUntilDone: false);
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
        
        
    }
    
    func initiateGallery() {
        if photosArray.count > 0 {
            firstImageView.image = photosArray[currentIndex]
            firstButton.isEnabled = false
            previousButton.isEnabled = false
            nextButton.isEnabled = true
            lastButton.isEnabled = true
            deleteButton.isEnabled = true
        }else{
            firstImageView.image = UIImage(named:"placeholder")
            firstButton.isEnabled = false
            previousButton.isEnabled = false
            nextButton.isEnabled = false
            lastButton.isEnabled = false
            deleteButton.isEnabled = false
        }
        
    }
    
    @IBAction func pressedCopyPhoto(_ sender: Any) {
        secondImageView.image = firstImageView.image
    }

    @IBAction func pressedFirstButton(_ sender: Any) {
        currentIndex = 0
        firstImageView.image = photosArray[currentIndex]
        previousButton.isEnabled = false
        firstButton.isEnabled = false
        nextButton.isEnabled = true
        lastButton.isEnabled = true
    }
    
    @IBAction func pressedNext(_ sender: Any) {
        currentIndex = currentIndex + 1;
        firstImageView.image = photosArray[currentIndex]
        if currentIndex >= photosArray.count - 1 {
            nextButton.isEnabled = false
            lastButton.isEnabled = false
        }
        previousButton.isEnabled = true
        firstButton.isEnabled = true
    }
    
    @IBAction func pressedPrevious(_ sender: Any) {
        currentIndex = currentIndex - 1;
        firstImageView.image = photosArray[currentIndex]
        if currentIndex <= 0 {
            previousButton.isEnabled = false
            firstButton.isEnabled = false
        }
        nextButton.isEnabled = true
        lastButton.isEnabled = true
    }
    
    @IBAction func pressedLast(_ sender: Any) {
        currentIndex = photosArray.count;
        firstImageView.image = photosArray.last
        previousButton.isEnabled = true
        firstButton.isEnabled = true
        nextButton.isEnabled = false
        lastButton.isEnabled = false
    }
    
    @IBAction func pressedDelete(_ sender: Any) {
        photosArray.remove(at: currentIndex)
        if photosArray.count == 0 {
            deleteButton.isEnabled = false
            firstImageView.image = UIImage(named:"placeholder")
            return
        }
        if currentIndex > 0 {
            currentIndex = currentIndex - 1
        }
        firstImageView.image = photosArray[currentIndex]
        
        if currentIndex <= 0 {
            previousButton.isEnabled = false
            firstButton.isEnabled = false
            nextButton.isEnabled = true
        }else if currentIndex >= photosArray.count - 1 {
            previousButton.isEnabled = true
            firstButton.isEnabled = true
            nextButton.isEnabled = false
        }
        if photosArray.count <= 1 {
            nextButton.isEnabled = false
            previousButton.isEnabled = false
            firstButton.isEnabled = false
            lastButton.isEnabled = false
        }
    }
    
}

