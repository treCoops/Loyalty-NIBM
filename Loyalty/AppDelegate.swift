//
//  AppDelegate.swift
//  Loyalty
//
//  Created by treCoops on 10/7/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import Firebase
import Connectivity
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //Get the simmulator path
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        FirebaseOP.instance.stopAllOperations()
        self.saveContext()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            //Make sure to add the merge policy so that not duplicates will be maintained on the coreData stack
            //Duplicate entries will be merged into the latest data
            //Inorder to add a constraint visit the DataModel.xcdatamodeled file and set a constraint name on the constraints section
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        //Make sure to add the merge policy so that not duplicates will be maintained on the coreData stack
        //Duplicate entries will be merged into the latest data
        //Inorder to add a constraint visit the DataModel.xcdatamodeled file and set a constraint name on the constraints section
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

