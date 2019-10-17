//
//  ViewController.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/14/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import UIKit

class SCProductTableViewController: UIViewController {

    @IBOutlet private weak var productsTableView: UITableView!
    let kProductTableViewCellIdentifier = "SCProductTableViewCell"
    var productViewModelArray: [SCProductViewModel] = []
    var pageCount = 1
    var isFetchingProducts = false
    var totalProductsCount = 0
    var activityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsTableView.register(UINib(nibName: kProductTableViewCellIdentifier,
                                         bundle: Bundle(for: SCProductTableViewCell.self)),
                                   forCellReuseIdentifier: kProductTableViewCellIdentifier)
        productsTableView.rowHeight = UITableView.automaticDimension
        productsTableView.estimatedRowHeight = 120
        productsTableView.prefetchDataSource = self
        
        activityIndicatorView.show(view: self.view)
        getProductList()
    }

    func getProductList() {
        isFetchingProducts = true
        SCApiServiceManager.sharedManager.getProductsList(page: pageCount, maxCount: K.Products.maxProductCount) { (result) in
            DispatchQueue.main.async {
                self.activityIndicatorView.hide()
                
                switch result {
                case .success(let productList) :
                    if let productArray =  productList.products {
                        let viewModelArray = productArray.map({ (product) -> SCProductViewModel in
                            SCProductViewModel(product: product)
                        })
                        
                        self.productViewModelArray.append(contentsOf: viewModelArray)
                    }
                    self.totalProductsCount = productList.totalProducts
                    self.isFetchingProducts = false
                    self.pageCount += 1
                    self.productsTableView.reloadData()
                    
                case .failure(_):
                    if self.pageCount == 1 {
                        self.showAlert()
                    }
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: K.SCError.title, message: K.SCError.fetchError , preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.getProductList()
        }))
        self.present(alert, animated: true, completion: nil)
        }
    }

// MARK: UITableViewDataSource
extension SCProductTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productsTableView.dequeueReusableCell(withIdentifier: kProductTableViewCellIdentifier) as? SCProductTableViewCell else { return UITableViewCell() }
       
        cell.productViewModel = productViewModelArray[indexPath.row]
        return cell
    }
}

// MARK: UITableViewDelegate
extension SCProductTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productPageViewController: SCProductPageViewController = SCProductPageViewController(productViewModelArray: productViewModelArray, totalProductsCount: totalProductsCount, pageCount: pageCount, startIndex: indexPath.row)
        self.navigationController?.pushViewController(productPageViewController, animated: true)
    }
}

// MARK: UITableViewDataSourcePrefetching
extension SCProductTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let productViewModelArrayCount = self.productViewModelArray.count
        
        if productViewModelArrayCount < totalProductsCount, let lastIndexPath = indexPaths.last , productViewModelArrayCount - lastIndexPath.row < 5, !isFetchingProducts {
            getProductList()
        }
    }
}
