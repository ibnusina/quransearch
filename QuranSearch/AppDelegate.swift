//
//  AppDelegate.swift
//  QuranSearch
//
//  Created by ibnu on 11/04/23.
//

import UIKit
import UIKit
import RealmSwift
import FirebaseCore
import FirebaseRemoteConfig

let localRealm = try! Realm(configuration: Realm.Configuration(readOnly: false, schemaVersion: 5, migrationBlock: { migration, oldSchemaVersion in }, deleteRealmIfMigrationNeeded: true))

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var remoteConfig: RemoteConfig!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        
        print("masup \(remoteConfig.configValue(forKey: "dummy_test_2").stringValue)")
        
        // [START fetch_config_with_callback]
            remoteConfig.fetch { (status, error) -> Void in
              if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { changed, error in
                    print("masup 1 s\(changed)")
                }
              } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
              }
                print("masup 3 \(self.remoteConfig.configValue(forKey: "dummy_test_2").stringValue)")
            }
        
        if localRealm.objects(Chapter.self).count <= 0 {
            loadLanguage()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

