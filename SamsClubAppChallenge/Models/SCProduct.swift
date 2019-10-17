//
//  SCProduct.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/14/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation

struct SCProduct: Codable {
    let productId: String
    let productName: String
    let shortDescription: String
    var longDescription: String
    let price: String
    let productImage: String
    let reviewRating: Double
    let reviewCount: Int
    let inStock: Bool
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId) ?? ""
        self.productName = try container.decodeIfPresent(String.self, forKey: .productName) ?? ""
        self.shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription) ?? ""
        self.longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription) ?? "Description Not Available"
        self.price = try container.decodeIfPresent(String.self, forKey: .price) ?? ""
        self.productImage = try container.decodeIfPresent(String.self, forKey: .productImage) ?? ""
        self.reviewRating = try container.decodeIfPresent(Double.self, forKey: .reviewRating) ?? 0.0
        self.reviewCount = try container.decodeIfPresent(Int.self, forKey: .reviewCount) ?? 0
        self.inStock = try container.decodeIfPresent(Bool.self, forKey: .inStock) ?? false
    }
    
    private enum CodingKeys: String, CodingKey {
        case productId, productName, shortDescription, longDescription, price,
            productImage, reviewRating, reviewCount, inStock
    }
}
