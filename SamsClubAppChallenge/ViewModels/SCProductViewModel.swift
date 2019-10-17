//
//  SCProductViewModel.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/15/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation
import UIKit

class SCProductViewModel {
    
    var product: SCProduct
    private(set) var productId: String
    private(set) var productName: String
    private(set) var price: String
    private(set) var productImage: String
    private(set) var reviewRating: Double
    private(set) var reviewCount: Int
    private(set) var inStock: Bool
    var image: UIImage?
    
    private(set) lazy var shortDescription: NSAttributedString = {
       return attributedString(description: product.shortDescription)
    }()
    
    private(set) lazy var longDescription: NSAttributedString = {
        return attributedString(description: product.longDescription)
    }()
    
    private(set) lazy var ratingString: String = {
        return ratingStarString(reviewRating: self.reviewRating)
    }()
    
    init(product: SCProduct) {
        self.product = product
        self.productId = product.productId
        self.productName = product.productName
        self.price = product.price
        self.productImage = product.productImage
        self.reviewRating = product.reviewRating
        self.reviewCount = product.reviewCount
        self.inStock = product.inStock
    }
    
    func attributedString(description: String) -> NSAttributedString {
        guard let data = description.data(using: .utf8) else { return NSAttributedString() }
        
        do {
            let attributedString = try NSMutableAttributedString(data: data,
                                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            let font = UIFont.systemFont(ofSize: 15.0)
            attributedString.addAttributes([NSAttributedString.Key.font : font],
                                     range: NSMakeRange(0, attributedString.length))

            return attributedString
        } catch {
          return NSAttributedString()
        }
    }
    
    func ratingStarString(reviewRating: Double) -> String {
        if reviewCount == 0 {
            return "No Ratings Yet"
        }
        
        let ratingsDisplay = [
            "☆☆☆☆☆",
            "★☆☆☆☆",
            "★★☆☆☆",
            "★★★☆☆",
            "★★★★☆",
            "★★★★★"
        ]
        let review = Int(reviewRating)
        return ratingsDisplay[review] + " (\(reviewCount))"
    }
    
    func fetchAndUpdateImage(completion: @escaping (UIImage?) -> ()) {
        if let image = SCImageCache.getImage(id: productId) {
            completion(image)
        }
        
        SCApiServiceManager.sharedManager.getImage(imageUrlString: productImage, completion: { (image) in
            if let image = image {
                self.image = image
                SCImageCache.saveImage(id: self.productId, image: image)
                completion(image)
            }
        })
    }
}

extension SCProductViewModel: Equatable {
    static func == (lhs: SCProductViewModel, rhs: SCProductViewModel) -> Bool {
        return lhs.productId == rhs.productId
    }
}
