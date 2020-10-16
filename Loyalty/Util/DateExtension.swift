//
//  DateToMills.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/11/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Utility class to convert currentdate to milliseconds
 */

import Foundation

extension Date {
    //get date in milliseconds
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    /**
        Converts the date in milliseconds to actual date format [MM-dd-yyyy]
     
        - parameter message : date in milliseconds
     
     */
    func getDateFromMills(dateInMills: Int64) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: (Double(dateInMills) / 1000.0)))
    }
}
