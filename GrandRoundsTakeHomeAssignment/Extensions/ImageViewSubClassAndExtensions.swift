//
//  ImageViewSubClassAndExtensions.swift
//  GrandRoundsTakeHomeAssignment
//
//  Created by Lakshmi Madhu on 7/16/19.
//  Copyright © 2019 Lakshmi Madhu. All rights reserved.
//

//Image Caching is implemented in order to load the images fast from url.
import Foundation
import UIKit


let imageCache = NSCache<AnyObject, AnyObject>()
class CacheImageView : UIImageView{
    //This is used  to cross check with urlstring before loading into imageview, to avoid mismatch of images on scroll etc...

    var imageUrlString  = String()
    
    func loadImageViewWithUrlString(urlString : String){
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            if error != nil{
                print(error?.localizedDescription ?? "Error occured while fetching image from url")
                return
            }
            
            
            if data == nil{
                print("No data found")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                
                let imageToCache = UIImage(data: data!)
                
                if self?.imageUrlString == urlString{
                    self?.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
            }.resume()
        
    }
}

