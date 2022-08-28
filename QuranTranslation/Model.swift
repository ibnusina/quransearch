//
//  Model.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 28/08/22.
//

import RealmSwift
import Foundation

public class Chapter: Object, Decodable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var chapterId: Int = 0
    @Persisted var name: String = ""
    @Persisted var transliteration: String = ""
    @Persisted var translation: String = ""
    @Persisted var type: String = ""
    @Persisted var totalVerses: Int = 0
    @Persisted var verses: List<Verse>
    
    public enum CodingKeys: String, CodingKey {
        case chapterId = "id"
        case name
        case transliteration
        case translation
        case type
        case totalVerses = "total_verses"
        case verses
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        chapterId = try container.decode(Int.self, forKey: .chapterId)
        name = try container.decode(String.self, forKey: .name)
        transliteration = try container.decode(String.self, forKey: .transliteration)
        translation = try container.decode(String.self, forKey: .translation)
        type = try container.decode(String.self, forKey: .type)
        totalVerses = try container.decode(Int.self, forKey: .totalVerses)
        verses = try container.decode(List<Verse>.self, forKey: .verses)
        
    }
}

public class Verse: Object, Decodable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var verseId: Int = 0
    @Persisted var text: String = ""
    @Persisted var translation: String
    
    internal enum CodingKeys: String, CodingKey {
        case verseId = "id"
        case text
        case translation
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        verseId = try container.decode(Int.self, forKey: .verseId)
        text = try container.decode(String.self, forKey: .text)
        translation = try container.decode(String.self, forKey: .translation)
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, keyPath: String?, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            if let keyPath = keyPath {
                return try decoder.decode(T.self, from: data, keyPath: keyPath)
            } else {
                return try decoder.decode(T.self, from: data)
            }
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
