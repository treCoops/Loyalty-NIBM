//
//  SessionManager.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    Utility class to manage the session of the user
 */

import Foundation

class SessionManager {
    
    //Holds the userstate in the application [LOGIN_STATE]
    /** Uses UserDefaults to store the attributes */
    static var authState : Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserSession.IS_LOGGED_IN)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserSession.IS_LOGGED_IN)
        }
    }
    
    //Save the session of the user as a JSON string on UserDefaults
    //Set the userstate as LOGGED
    static func saveUserSession(_ user: User) {
        if let jsonData = try? JSONEncoder().encode(user){
            let data = String(data: jsonData, encoding: String.Encoding.utf8)
            UserDefaults.standard.set(true, forKey: UserSession.IS_LOGGED_IN)
            UserDefaults.standard.set(data, forKey: UserSession.USER_SESSION)
        } else {
            NSLog("JSON SERIALIZATION FAILED")
        }
    }
    
    //Retrieve the current usersession JSON from UserDefaults and returns it as User Type
    static func getUserSesion() -> User? {
        
        //Check whether previous sessions exists
        guard let session = UserDefaults.standard.string(forKey: UserSession.USER_SESSION) else {
            NSLog("No previous sessions found")
            return nil
        }
        
        NSLog("Previous Sessions found")

        //Serializae the JSON string and decode it as User Type
        if let user = try? JSONDecoder().decode(User.self, from: session.data(using: .utf8)!) {
            return user
        }
    
        return nil
    }
    
    //Clears all saved sessions
    static func clearUserSession(){
        UserDefaults.standard.removeObject(forKey: UserSession.USER_SESSION)
        UserDefaults.standard.removeObject(forKey: UserSession.IS_LOGGED_IN)
    }
    
}
