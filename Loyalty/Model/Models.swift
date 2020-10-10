//
//  Models.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation


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
    
    init(name: String?, studentID: String?, mobile: String?, nic: String?, joinedDate: String?, email: String?, password: String?, profileImage: String?, status: Int?) {
        self.name = name
        self.studentID = studentID
        self.mobile = mobile
        self.nic = nic
        self.joinedDate = joinedDate
        self.email = email
        self.password = password
        self.profileImage = profileImage
        self.status = status
    }
    
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
    }
}
