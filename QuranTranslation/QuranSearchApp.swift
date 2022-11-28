//
//  QuranTranslationApp.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/08/22.
//

import SwiftUI
import RealmSwift

let localRealm = try! Realm(configuration: Realm.Configuration(readOnly: false, schemaVersion: 4, migrationBlock: { migration, oldSchemaVersion in }, deleteRealmIfMigrationNeeded: true))

@main
struct QuranSearchApp: SwiftUI.App {
    init() {
        
        
        if localRealm.objects(Chapter.self).count <= 0 {
            let chapters = Bundle.main.decode([Chapter].self, from: "quran_en.json", keyPath: "quran")
            
            try! localRealm.write {
                localRealm.add(chapters)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            VerseListView()
        }
    }
}



