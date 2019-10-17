//
//  SCProductsList.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/14/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation

struct SCProductsList: Codable {
    var products: [SCProduct]?
    var totalProducts: Int
    var pageNumber: Int
    var pageSize: Int
    var statusCode: Int
}
