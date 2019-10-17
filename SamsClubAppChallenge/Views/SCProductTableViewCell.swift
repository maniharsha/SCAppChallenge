//
//  SCProductTableViewCell.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/15/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation
import UIKit

class SCProductTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var outOfStockLabel: UILabel!
   
    var productViewModel: SCProductViewModel? {
        didSet {
            guard let productViewModel = productViewModel else { return }
            titleLabel.text = productViewModel.productName
            shortDescriptionLabel.attributedText = productViewModel.shortDescription
            priceLabel.text = productViewModel.price
            ratingLabel.text = productViewModel.ratingString
            outOfStockLabel.isHidden = productViewModel.inStock
            
            if let image = productViewModel.image {
                productImageView.image = image
            } else {
                productImageView.image = UIImage(named: "Placeholder")
                productViewModel.fetchAndUpdateImage { [productViewModel, weak self] (image) in
                    guard let self = self, let image = image else {return}
                    if self.productViewModel == productViewModel {
                        DispatchQueue.main.async {
                            self.productImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
    }
}
