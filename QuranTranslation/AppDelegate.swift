//
//  AppDelegate.swift
//  QuranSearch
//
//  Created by ibnu on 09/04/23.
//

import Foundation
import UIKit
import SwiftUI
import RealmSwift

let localRealm = try! Realm(configuration: Realm.Configuration(readOnly: false, schemaVersion: 4, migrationBlock: { migration, oldSchemaVersion in }, deleteRealmIfMigrationNeeded: true))

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        if localRealm.objects(Chapter.self).count <= 0 {
//            loadLanguage()
//        }
        let navigation = UINavigationController(rootViewController: SearchVC())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
//        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }
}
