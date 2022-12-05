//
//  Language.swift
//  QuranTranslation
//
//  Created by Ibnu Sina on 30/11/22.
//

import Foundation

internal struct LanguageDirectory: Codable, Identifiable, Hashable {
    var id: String { code.rawValue }
    
    internal let file: String
    internal let flag: String
    internal let name: String
    internal let code: LanguageCode
}

internal enum LanguageCode: String, Codable {
    case EN = "en"
    case ID = "id"
}

internal let translationLanguages: [LanguageDirectory] = [
    LanguageDirectory(file: "quran_id.json", flag: "🇮🇩", name: "Indonesia", code: .ID),
    LanguageDirectory(file: "quran_en.json", flag: "🇬🇧", name: "English", code: .EN)
]

internal let translationStorageKey: String = "translationStorageKey"

internal func loadLanguage(_ language: LanguageDirectory? = nil) {
    let newLanguage: LanguageDirectory = language ?? ((UserDefaults.standard.object(forKey: translationStorageKey) as? LanguageDirectory) ?? translationLanguages[0])
    
    let chapters = Bundle.main.decode([Chapter].self, from: newLanguage.file, keyPath: nil)
    
    try! localRealm.write {
        localRealm.deleteAll()
        localRealm.add(chapters)
    }
    
    UserDefaults.setLanguage(newLanguage)
}

extension UserDefaults {
    internal static func setLanguage(_ language: LanguageDirectory? = nil) {
        guard let language = language else {
            UserDefaults.standard.set(nil, forKey: translationStorageKey)
            return
        }
        
        if let encoded = try? JSONEncoder().encode(language) {
            UserDefaults.standard.set(encoded, forKey: translationStorageKey)
        }
    }
    
    internal static func getLanguage() -> LanguageDirectory {
        let language: LanguageDirectory
        if let data = UserDefaults.standard.object(forKey: translationStorageKey) as? Data,
           let newLanguage = try? JSONDecoder().decode(LanguageDirectory.self, from: data) {
            language = newLanguage
        } else if let languageCode = Locale.current.languageCode, let newLanguage = translationLanguages.first(where: { language in
            return language.code.rawValue == languageCode
        }) {
            language = newLanguage
            UserDefaults.setLanguage(language)
        } else {
            language = translationLanguages[0]
            UserDefaults.setLanguage(language)
        }
        return language
    }
}


