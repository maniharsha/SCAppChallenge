//
//  SCImageCache.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/16/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation
import UIKit

class SCImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    static func saveImage(id: String, image: UIImage)  {
        SCImageCache.shared.setObject(image, forKey: id as NSString)
    }
    
    static func getImage(id: String) -> UIImage? {
       return SCImageCache.shared.object(forKey: id as NSString)
    }
}
