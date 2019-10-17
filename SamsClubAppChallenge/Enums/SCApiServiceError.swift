//
//  SCApiServiceError.swift
//  SamsClubAppChallenge
//
//  Created by Anne, Mani on 10/16/19.
//  Copyright © 2019 ManiAnne. All rights reserved.
//

import Foundation

enum SCApiServiceError: Error {
    case unKnownError
    case serverError
    case decodingError
}
