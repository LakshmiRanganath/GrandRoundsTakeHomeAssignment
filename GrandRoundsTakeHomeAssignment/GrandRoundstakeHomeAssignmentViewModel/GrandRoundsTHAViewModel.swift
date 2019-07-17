//
//  GrandRoundsTHAViewModel.swift
//  GrandRoundsTakeHomeAssignment
//
//  Created by Lakshmi Madhu on 7/16/19.
//  Copyright © 2019 Lakshmi Madhu. All rights reserved.
//

import Foundation

class GrandRoundsTHAViewModel : NSObject{

    func fetchImagesForSearchString(searchString : String, pageCount : Int, completion : @escaping(Result<[IndividualPhotoDetail], Error>) -> ()){
        
        //Forming URL from its components and queryParameters
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.flickr.com"
        urlComponents.path = "/services/rest"
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: FlickerAPIKey().flickerAPIKey),
            URLQueryItem(name: "text", value: searchString),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "per_page", value: "9"),
            URLQueryItem(name: "page", value: String(pageCount)),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        guard let searchURL = urlComponents.url else {
            return
        }

        URLSession.shared.dataTask(with: searchURL){(data, response, error) in
            if (error != nil){
                completion(.failure(error!))
            }
            else{
                if (data != nil){
                    do{
                        let jsonFlikerAPI = try JSONDecoder().decode(JSONFlikerAPI.self, from: data!)
                        completion(.success(jsonFlikerAPI.photos.photo))
                    }catch let jsonError{
                        completion(.failure(jsonError))
                    }
                    
                }
                
            }
            }.resume()
    }
    
}
