//
//  SCProductDetailViewController.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/16/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation
import UIKit

class SCProductDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var productContentView: UIView!
    @IBOutlet weak var outOfStockLabel: UILabel!
    
    var isFetchingData: Bool = false
    var activityIndicatorView = UIActivityIndicatorView()
    var pageIndex = 0
    var productViewModel: SCProductViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFetchingData {
            activityIndicatorView.show(view: self.view)
        } else {
            updateContent()
        }
    }
    
    func updateContent() {
        guard let productViewModel = productViewModel else { return }
        titleLabel.text = productViewModel.productName
        shortDescriptionLabel.attributedText = productViewModel.shortDescription
        longDescriptionLabel.attributedText = productViewModel.longDescription
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
    
    func didReceiveData(productViewModel: SCProductViewModel?, error: Error?) {
        activityIndicatorView.hide()
       
        if error != nil || productViewModel == nil {
            showAlert()
        } else {
            self.productViewModel = productViewModel
            updateContent()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: K.SCError.title, message: K.SCError.fetchError , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
