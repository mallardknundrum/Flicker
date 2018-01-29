//
//  NetworkController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import Foundation
class NetworkController {
    
    // MARK: Properties
    let baseURLString =  "https://api.flickr.com/services/rest/?method="
    let APIKey = "0ad4bccce5437a0c295129443a09d2fa"
    
    enum flickerAPIMethods: String {
        case searchForUser = "flickr.people.findByUsername"
        case getPopular = "flickr.interestingness.getList"
        case getPhotosForUser = "flickr.people.getPublicPhotos"
        
    }
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    func performRequest(for flickerAPIMethod: flickerAPIMethods,
                               httpMethod: HTTPMethod,
                               urlParameters: [String : String]? = nil,
                               body: Data? = nil,
                               completion: ((Data?, Error?) -> Void)? = nil) {
        
        // Build our entire URL
        let requestURL = self.url(for: flickerAPIMethod, byAdding: urlParameters)
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        // Create and "resume" (a.k.a. run) the task
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            completion?(data, error)
        }
        
        dataTask.resume()
    }
    
    private func url(for flickerAPIMethod: flickerAPIMethods, byAdding parameters: [String : String]?) -> URL {
        var parameters = parameters
        parameters?["method"] = flickerAPIMethod.rawValue
        parameters?["api_key"] = APIKey
        parameters?["format"] = "json"
        parameters?["nojsoncallback"] = "1"
        guard let baseURL = URL(string: baseURLString) else { fatalError("BaseURL cannot be converted into URL")}
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.flatMap({ URLQueryItem(name: $0.0, value: $0.1) })
        
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        print(url)
        return url
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, error)
        }
        dataTask.resume()
    }
}
