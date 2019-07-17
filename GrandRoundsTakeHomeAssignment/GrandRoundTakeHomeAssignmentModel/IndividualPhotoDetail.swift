//
//  IndividualPhotoDetail.swift
//  GrandRoundsTakeHomeAssignment
//
//  Created by Lakshmi Madhu on 7/16/19.
//  Copyright © 2019 Lakshmi Madhu. All rights reserved.
//

import Foundation
struct IndividualPhotoDetail : Codable {
    var id = String()
    var owner = String()
    var secret = String()
    var server = String()
    var farm = Int()
    var title = String()
    var ispublic = Int()
    var isfriend = Int()
    var isfamily = Int()
}
