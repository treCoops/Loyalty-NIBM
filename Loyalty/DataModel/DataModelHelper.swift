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
    
    //Category based operations. Fetch categories and returns
    static func fetchCategories(request: NSFetchRequest<Category> = Category.fetchRequest()) -> [Category]? {
        //default fetch request which fetches all the categories
        do {
            let category = try context.fetch(request)
            return category
        } catch {
            print("Runtime error on fetching categories data from Context \(error)")
        }
        return []
    }
    
    //Search categories using the provided searchText (custom predicate) and returns
    static func searchCategories(category: String) -> [Category]?{
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        //predicate to check whether entered data matches the data on the core data stack
        //equal to LIKE query [cd] = case intensive
        request.predicate = NSPredicate(format: "categoryName CONTAINS[cd] %@", category)
        return fetchCategories(request: request)
    }
    
    //Get vendors using the provided fetchRequest otherwise fetch all vendors based on category
    static func fetchVendors(category: String, vendorName: String?) -> [Vendor]? {
        let request: NSFetchRequest<Vendor> = Vendor.fetchRequest()
        let defaultPredicate = NSPredicate(format: "category = %@", category)
        if let vendorName = vendorName {
            NSLog("Filter using vendor name")
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [defaultPredicate, NSPredicate(format: "name CONTAINS[cd] %@", vendorName)])
            request.predicate = andPredicate
        } else {
            request.predicate = defaultPredicate
        }
        do {
            return try context.fetch(request)
        } catch {
            print("Runtime error on fetching vendor data from Context \(error)")
        }
        
        return []
    }
    
    //fetch all offers and returns based on tht provided parameters
    static func fetchOffers(fetchFeatured: Bool) -> [Offer]? {
        let request: NSFetchRequest<Offer> = Offer.fetchRequest()
        //set the predicate if the [fetchFeatured] parameter is TRUE
        if fetchFeatured {
            request.predicate = NSPredicate(format: "is_featured = %d", true)
        }
        do {
            return try context.fetch(request)
        } catch {
            print("Runtime error on fetching offer data from Context \(error)")
        }
        return []
    }
    
    //fetch offers based on a specific vendor name
    static func fetchOffers(vendorKey: String) -> [Offer]? {
        let request: NSFetchRequest<Offer> = Offer.fetchRequest()
        //set predicate to filter out with a specific vendor
        request.predicate = NSPredicate(format: "vendorId = %@", vendorKey)
        do {
            return try context.fetch(request)
        } catch {
            print("Runtime error on fetching offer data from Context \(error)")
        }
        
        return []
    }
    
    //Fetch all the vendor images and returns
    static func requestVendorImage(request: NSFetchRequest<Vendor>) -> String? {
        do {
            return try context.fetch(request).first?.profileImageUrl
        } catch {
            print("Runtime error on fetching vendor profile image data from Context \(error)")
        }
        return nil
    }
}
