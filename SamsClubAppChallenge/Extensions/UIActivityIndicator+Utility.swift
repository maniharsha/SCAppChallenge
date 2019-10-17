//
//  UIActivityIndicator+Utility.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/16/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    func show(view: UIView) {
        self.frame = view.frame
        self.style = .whiteLarge
        self.hidesWhenStopped = true
        self.center = view.center
        self.backgroundColor = UIColor.lightGray
        view.addSubview(self)
        self.startAnimating()
    }
    
    func hide() {
        self.stopAnimating()
        self.removeFromSuperview()
    }
}
