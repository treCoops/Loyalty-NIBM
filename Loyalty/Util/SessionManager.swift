//
//  SessionManager.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/10/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import Foundation

class SessionManager {
    
    static var authState : Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserSession.IS_LOGGED_IN)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserSession.IS_LOGGED_IN)
        }
    }
    
    static func saveUserSession(_ user: User) {
        if let jsonData = try? JSONEncoder().encode(user){
            let data = String(data: jsonData, encoding: String.Encoding.utf8)
            UserDefaults.standard.set(true, forKey: UserSession.IS_LOGGED_IN)
            UserDefaults.standard.set(data, forKey: UserSession.USER_SESSION)
        } else {
            NSLog("JSON SERIALIZATION FAILED")
        }
    }
    
    static func getUserSesion() -> User? {
        
        guard let session = UserDefaults.standard.string(forKey: UserSession.USER_SESSION) else {
            NSLog("No previous sessions found")
            return nil
        }
        
        NSLog("Previous Sessions found")

        if let user = try? JSONDecoder().decode(User.self, from: session.data(using: .utf8)!) {
            return user
        }
    
        return nil
    }
    
    static func clearUserSession(){
        UserDefaults.standard.removeObject(forKey: UserSession.USER_SESSION)
        UserDefaults.standard.removeObject(forKey: UserSession.IS_LOGGED_IN)
    }
    
}
