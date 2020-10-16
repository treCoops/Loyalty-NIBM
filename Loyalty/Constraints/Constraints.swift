//
//  Constraints.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Class which holds all constraints related to the application
 */

import Foundation

//Name of the Seagues
struct Seagus {
    static var launchScreenToSignIn = "launchScreenToSignIn"
    static var launchScreenToSignUp = "launchScreenToSignUp"
    static var signUpOneToSignUpTwo = "signUpOneToSignUpTwo"
    static var signUpTwoToHome = "signUpTwoToHome"
    static var launchToHome = "launchToHome"
    static var signInToSignUp = "signInToSignUp"
    static var signInToHome = "signInToHome"
    static var categoryToSingleCategory = "categoryToSingleCategory"
    static var singleCategoryToVendor = "singleCategoryToVendor"
    static var vendorToViewOffer = "vendorToViewOffer"
    static var HomeToSearch = "HomeToSearch"
    static var HomeToProfile = "HomeToProfile"
    static var HomeToSingleCategory = "HomeToSingleCategory"
    static var SearchToVendor = "SearchToVendor"
    static var ViewOfferToValidationDone = "ViewOfferToValidationDone"
    static var ViewOfferToValidationError = "ViewOfferToValidationError"
    static var ScanQRToViewOffer = "ScanQRToViewOffer"
    static var ViewOfferToScanQR = "ViewOfferToScanQR"
}

//Names of the XIB Files
struct XIBIdentifier {
    static var XIB_HISTORY_CELL = "ReuseableCellHistory"
    static var XIB_HISTORY = "HistoryTableViewCell"
    
    static var XIB_SEARCH_RESULT_CELL = "ReusableCellSearchResult"
    static var XIB_SEARCH_RESULT = "SearchResultTableViewCell"
    
    static var FeaturedCollectionViewCell = "LogoCell"
    static var FeaturedCellReuseable = "FeaturedCellReuseable"
    
    static var XIB_OFFER_CELL = "ReuseableCellOffer"
    static var XIB_OFFER = "OfferTableViewCell"
    
    static var XIB_VENDOR_CELL = "ReuseableCellVendor"
    static var XIB_VENDOR = "VendorTableViewCell"
    
}

//Captions for the Errors (Validation Errors, Response Errors)
struct FieldErrorCaptions {
    static let txtNameErrCaption = "Enter a valid name"
    static let txtNICErrCaption = "Enter a valid NIC no."
    static let txtStudentIDErrCaption = "Enter a valid StudentID"
    static let txtEmailErrCaption = "Enter a valid Email"
    static let txtContactNoErrCaption = "Enter a valid Contact no."
    static let txtPassErrCaption = "Password length should be 6-20"
    static let txtConfirmPassErrCaption = "Passwords don't match"
    
    static let searchFieldIsEmptyErrCaption = "Search field is empty"
    
    static let generalizeErrCaption = "Oops! Something went wrong!"
    static let userCreationrrCaption = "Unable to create new user!"
    static let userAlreadyExistsErrCaption = "A user with the same NIC has already registered with the system!"
    
    static let categoryLoadFailedErrCaption = "Unable to load categories"
    static let categoryDataIsEmpty = "No categories found"
    
    static let offersLoadFailedErrCaption = "Unable to load offers"
    static let offersDataIsEmpty = "No offers found"
    
    static let vendorsLoadFailedErrCaption = "Unable to load vendors"
    static let vendorDataIsEmpty = "No vendors found"
    
    static let claimedOffersLoadFailedErrCaption = "Unable to load claimed offers"
    static let claimedOffersDataIsEmpty = "No claimed offers found"
    
    static let scannerOfferNotValidTitle = "Offer not valid"
    static let scannerOfferNotValidDescription = "Could not find a valid offer, please try again."
    
    static let offerValidationErr = "Could not validate the offer"
    
    static let offerClaimErrDescription = "Could not claim the offer"
    
    static let noConnectionTitle = "No connection"
    static let noConnectionMessage = "The app requires a working internet connection please check your connection settings."
}

//NIBM API authentication credentials and URL info
struct NIBMAuth {
    static let authKey = "4f996843b9427aa4b5c59660867f7df1f07211f7"
    static let authUrl : String = "http://api-examresults.azurewebsites.net/api/Students/IsValid?authKey=\(authKey)&NicNo="
}

//Name of the SessionVariables
struct UserSession {
    static let USER_SESSION = "USER_SESSION"
    static let IS_LOGGED_IN = "AUTH_STATE"
}

//Default credentials for the account
struct DefaultCredentials {
    static let defaultEmail = "appuser@gmail.com"
    static let defaultPass = "TrincoBaby"
}

struct AppConfig {
    static let connectionCheckTimeout: Double = 10
}

