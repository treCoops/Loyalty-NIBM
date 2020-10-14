//
//  DataModelHelper.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/14/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
    A helper class to communicate with the coreData stack
 */

class DataModelHelper {
    //get the application context which the coreData will work on in prior to save and comit the changes made to the data
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //commiting and saving the changes which were performed to the data. (save to coreData stack)
    static func saveContext(){
        do {
            try context.save()
        } catch {
            NSLog("Runtime Error on saving Context \(error)")
        }
    }
    
    //Category based operations
    static func fetchCategories() -> [Category]? {
        //default fetch request which fetches all the categories
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            let category = try context.fetch(request)
            return category
        } catch {
            print("Runtime error on fetching categories data from Context")
        }
        return nil
    }
    
    static func fetchOffers(fetchFeatured: Bool) -> [Offer]? {
        let request: NSFetchRequest<Offer> = Offer.fetchRequest()
        if fetchFeatured {
            request.predicate = NSPredicate(format: "is_featured = %d", true)
        }
        do {
            let offer = try context.fetch(request)
            return offer
        } catch {
            print("Runtime error on fetching offer data from Context")
        }
        return nil
    }
    
    static func requestVendorImage(request: NSFetchRequest<Vendor>) -> String? {
        do {
            return try context.fetch(request).first?.profileImageUrl
        } catch {
            print("Runtime error on fetching vendor profile image data from Context")
        }
        return nil
    }
}
