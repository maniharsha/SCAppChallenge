//
//  SCProductPageViewController.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/16/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation
import UIKit

class SCProductPageViewController: UIPageViewController {
    
    var productViewModelArray: [SCProductViewModel] = []
    var totalProductsCount = 0
    var pageCount = 0
    var startIndex = 0
    typealias fetchCompletionHandler = (SCProductViewModel?, Error?) -> ()

    convenience init(productViewModelArray: [SCProductViewModel], totalProductsCount: Int, pageCount: Int, startIndex: Int) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.productViewModelArray = productViewModelArray
        self.totalProductsCount = totalProductsCount
        self.pageCount = pageCount
        self.startIndex = startIndex
        
        self.delegate = self
        self.dataSource = self
        
        if let detailVC = viewControllerFor(index: startIndex) {
            self.setViewControllers([detailVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func viewControllerFor(index: Int) -> SCProductDetailViewController? {
        if index < 0 || index >= totalProductsCount  { return nil }
        
        guard let detailVC = getDetailVC() else { return nil }
        detailVC.pageIndex = index

        if index == productViewModelArray.count && index < totalProductsCount {
            detailVC.isFetchingData = true
            fetchData(index: index) { [weak  detailVC] (productViewModel, error) in
                if let detailVC = detailVC {
                    detailVC.isFetchingData = false
                    detailVC.didReceiveData(productViewModel: productViewModel, error: nil)
                }
            }
        } else {
            detailVC.productViewModel = productViewModelArray[index]
        }
        
        return detailVC
    }
    
    func getDetailVC() -> SCProductDetailViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: SCProductDetailViewController.self))
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "SCProductDetailViewController") as? SCProductDetailViewController
        return detailVC
    }
    
    func fetchData(index: Int, completion: @escaping fetchCompletionHandler) {
        SCApiServiceManager.sharedManager.getProductsList(page: self.pageCount, maxCount: K.Products.maxProductCount) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let productList) :
                    self.didReceivedProductList(productList: productList, index: index, completion: completion)
                    
                case .failure(_):
                    completion(nil, nil)
                }
            }
        }
    }
    
    func didReceivedProductList(productList: SCProductsList, index: Int, completion: @escaping fetchCompletionHandler)  {
        if let productArray =  productList.products {
            let viewModelArray = productArray.map({ (product) -> SCProductViewModel in
                SCProductViewModel(product: product)
            })
            
            self.productViewModelArray.append(contentsOf: viewModelArray)
        }
        
        self.pageCount += 1
        
        if index < self.productViewModelArray.count {
            let viewModel =  self.productViewModelArray[index]
            completion(viewModel, nil)
        } else {
            completion(nil, nil)
        }
    }
}

// MARK: UIPageViewControllerDataSource
extension SCProductPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let detailVC = viewController as? SCProductDetailViewController else {
            return nil
        }
        
        return viewControllerFor(index: detailVC.pageIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let detailVC = viewController as? SCProductDetailViewController, !detailVC.isFetchingData else {
            return nil
        }
        
        return viewControllerFor(index: detailVC.pageIndex + 1)
    }
}

// MARK: UIPageViewControllerDelegate
extension SCProductPageViewController: UIPageViewControllerDelegate {
    
}
