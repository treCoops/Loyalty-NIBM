//
//  Models.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Structures which holds the models
 */

import Foundation

//User Model
struct User : Codable {
    var name: String?
    var studentID: String?
    var mobile: String?
    var nic: String?
    var joinedDate: String?
    var email: String?
    var password: String?
    var profileImage: String?
    var status: Int?
    var timeStamp: Int64?
    
    init(name: String?, studentID: String?, mobile: String?, nic: String?, joinedDate: String?, email: String?, password: String?, profileImage: String?, status: Int?, timeStamp: Int64?) {
        self.name = name
        self.studentID = studentID
        self.mobile = mobile
        self.nic = nic
        self.joinedDate = joinedDate
        self.email = email
        self.password = password
        self.profileImage = profileImage
        self.status = status
        self.timeStamp = timeStamp
    }
    
    //Constructor which is used when decoding or encoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.studentID = try container.decodeIfPresent(String.self, forKey: .studentID)
        self.mobile = try container.decodeIfPresent(String.self, forKey: .mobile)
        self.nic = try container.decodeIfPresent(String.self, forKey: .nic)
        self.joinedDate = try container.decodeIfPresent(String.self, forKey: .joinedDate)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.password = try container.decodeIfPresent(String.self, forKey: .password)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.timeStamp = try container.decodeIfPresent(Int64.self, forKey: .timeStamp)
    }
}

struct Claim {
    var offerId: String?
    var offerTitle: String?
    var timestamp: Int64?
    var userId: String?
    var userName: String?
    
    init(offerId: String?, offerTitle: String?, timestamp: Int64?, userId: String?, userName: String?) {
        self.offerId = offerId
        self.offerTitle = offerTitle
        self.timestamp = timestamp
        self.userId = userId
        self.userName = userName
    }
}

//class Category {
//    var categoryName: String?
//    var coverImage: String?
//    var key: String?
//
//    init(categoryName: String, coverImage: String, key: String) {
//        self.categoryName = categoryName
//        self.coverImage = coverImage
//        self.key = key
//    }
//}

//class Offer {
//    var key: String?
//    var description: String?
//    var title: String?
//    var image: String?
//    var vendor: String?
//    var vendorId: String?
//    var status: Int?
//    
//    init(key: String, description: String, title: String, image: String, vendor: String, vendorId: String, status: Int) {
//        self.key = key
//        self.description = description
//        self.title = title
//        self.image = image
//        self.vendor = vendor
//        self.vendorId = vendorId
//        self.status = status
//    }
//}


