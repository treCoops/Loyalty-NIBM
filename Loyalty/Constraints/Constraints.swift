//
//  Constraints.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation

struct Seagus {
    static var launchScreenToSignIn = "launchScreenToSignIn"
    static var launchScreenToSignUp = "launchScreenToSignUp"
    static var signUpOneToSignUpTwo = "signUpOneToSignUpTwo"
    static var signUpTwoToHome = "signUpTwoToHome"
}

struct XIBIdentifier {
    static var XIB_HISTORY_CELL = "ReuseableCellHistory"
    static var XIB_HISTORY = "HistoryTableViewCell"
    
    static var XIB_PROMOTION_CELL = "ReuseableCellPromotion"
    static var XIB_PROMOTION = "PromotionTableViewCell"
    
    static var FeaturedCollectionViewCell = "LogoCell"
    static var FeaturedCellReuseable = "FeaturedCellReuseable"
    
    static var XIB_OFFER_CELL = "ReuseableCellOffer"
    static var XIB_OFFER = "OfferTableViewCell"
    
    static var XIB_OFFER_VENDOR_CELL = "ReuseableCellVendorOffer"
    static var XIB_OFFER_VENDOR = "VenderOfferTableViewCell"
    
}

struct FieldErrorCaptions {
    static let txtNameErrCaption = "Enter a valid name"
    static let txtNICErrCaption = "Enter a valid NIC no."
    static let txtStudentIDErrCaption = "Enter a valid StudentID"
    static let txtEmailErrCaption = "Enter a valid Email"
    static let txtContactNoErrCaption = "Enter a valid Contact no."
    static let txtPassErrCaption = "Password length should be 6-20"
    static let txtConfirmPassErrCaption = "Passwords don't match"
    
    static let generalizeErrCaption = "Oops! Something went wrong!"
    static let userCreationrrCaption = "Unable to create new user!"
}

struct NIBMAuth {
    static let authKey = "4f996843b9427aa4b5c59660867f7df1f07211f7"
    static let authUrl : String = "http://api-examresults.azurewebsites.net/api/Students/IsValid?authKey=\(authKey)&NicNo="
}

struct UserSession {
    static let USER_SESSION = "USER_SESSION"
    static let IS_LOGGED_IN = "AUTH_STATE"
}

struct DefaultCredentials {
    static let defaultEmail = "appuser@gmail.com"
    static let defaultPass = "TrincoBaby"
}

