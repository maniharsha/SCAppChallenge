//
//  Constants.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/15/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation

struct K {
    struct API {
        static let baseURL = "https://mobile-tha-server.firebaseapp.com/walmartproducts"
        static let baseImageURL = "https://mobile-tha-server.firebaseapp.com"
    }
    
    struct Products {
        static let maxProductCount = 30
    }
    
    struct SCError {
        static let title = "Attention"
        static let fetchError = "Error occured while fetching products"
    }
}
