//
//  SCApiServiceManager.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/15/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation
import UIKit

class SCApiServiceManager {
    static let sharedManager = SCApiServiceManager()
    var defaultsession = URLSession.shared

    func getProductsList(page: Int, maxCount: Int, completion: @escaping (Result<SCProductsList, SCApiServiceError>) -> ())  {
        
        let urlString = K.API.baseURL + "/\(page)" + "/\(maxCount)"
        guard let url = URL(string: urlString) else { return }
       
        defaultsession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.serverError))
                return
            }
            
            //When statusCode is contained in 200...299, the response is OK.
            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                if let data = data {
                    do {
                        let productsList = try JSONDecoder().decode(SCProductsList.self, from: data)
                        completion(.success(productsList))
                        return
                    } catch {
                        completion(.failure(.decodingError))
                    }
                } else {
                    completion(.failure(.serverError))
                    return
                }
            }
            completion(.failure(.unKnownError))
        }.resume()
    }
    
    func getImage(imageUrlString: String, completion: @escaping (UIImage?) -> ()) {
        let urlString = K.API.baseImageURL + imageUrlString
        guard let url = URL(string: urlString) else { return }
        
        defaultsession.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
            
            completion(nil)
        }.resume()
    }
}
