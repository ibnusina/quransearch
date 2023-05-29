//
//  Model.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 28/08/22.
//

import Realm
import RealmSwift
import Foundation

public class Chapter: Object, Decodable, Identifiable {
    public var id: String {
        "\(chapterId)"
    }
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var chapterId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var transliteration: String = ""
    @objc dynamic var translation: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var totalVerses: Int = 0
    var verses: List<Verse> = List<Verse>()

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
    
    override public class func primaryKey() -> String? {
        return "_id"
    }
}

public class Verse: Object, Decodable, Identifiable {
    public var id: String {
        "\(_id.description)"
    }
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var verseId: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var translation: String = ""

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
    
    override public class func primaryKey() -> String? {
        return "_id"
    }
}

public class Bookmark: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var chapterId: Int = 0
    @objc dynamic var verseId: Int = 0
    
    public convenience init(chapterId: Int, verseId: Int) {
        self.init()
        self.chapterId = chapterId
        self.verseId = verseId
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
            fatalError("Failed - to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
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
