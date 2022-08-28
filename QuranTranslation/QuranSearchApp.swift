//
//  QuranTranslationApp.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/08/22.
//

import SwiftUI
import RealmSwift

@main
struct QuranSearchApp: SwiftUI.App {
    init() {
        let localRealm = try! Realm(configuration: Realm.Configuration(readOnly: false, schemaVersion: 3, migrationBlock: { migration, oldSchemaVersion in }, deleteRealmIfMigrationNeeded: true))
        
        if localRealm.objects(Chapter.self).count <= 0 {
            let chapters = Bundle.main.decode([Chapter].self, from: "quran_en.json", keyPath: "quran")
            
            try! localRealm.write {
                localRealm.add(chapters)
            }
        } else {
            let verses = localRealm.objects(Verse.self).where {
                $0.translation.contains(" war ")
            }
            for verse in verses {
                let chapter = localRealm.objects(Chapter.self).where {
                    $0.verses.contains(verse)
                }
                print(verse.translation)
                print("\(chapter.first!.transliteration) \(chapter.first!.translation) \(chapter.first!.chapterId)")
            }
            
        }
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}



