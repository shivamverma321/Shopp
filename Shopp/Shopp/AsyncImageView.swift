//
//  AsyncImageView.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

public class AsyncImageView: UIImageView {
    
    var placeholderImage: UIImage?
    
    private var cached = false
    
    var firebaseURL: String? {
        didSet{
            self.image = placeholderImage
            
            //fetches image from storage
            if let firebaseURL = firebaseURL{
                let imageRef = Storage.storage().reference(forURL: firebaseURL)
                imageRef.getData(maxSize: 100*1024*1024, completion: { (data, error) in
                    if let data = data{
                        if let image = UIImage(data: data){
                            self.image = image
                        }
                    }
                })
            }
        }
    }
    
    func setFirebaseURL(firebaseURL: String?, placeholderImage: UIImage? = UIImage(color: UIColor.lightGray)) {
        if !cached || (self.firebaseURL != firebaseURL){
            self.placeholderImage = placeholderImage
            self.firebaseURL = firebaseURL
            cached = true
        }
    }
    
}

