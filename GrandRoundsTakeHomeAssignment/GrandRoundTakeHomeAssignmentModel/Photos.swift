//
//  Photos.swift
//  GrandRoundsTakeHomeAssignment
//
//  Created by Lakshmi Madhu on 7/16/19.
//  Copyright © 2019 Lakshmi Madhu. All rights reserved.
//

import Foundation


struct Photos : Codable {
    var page = Int()
    var pages = Int()
    var perpage = Int()
    var total = String()
    var photo = [IndividualPhotoDetail]()
}
