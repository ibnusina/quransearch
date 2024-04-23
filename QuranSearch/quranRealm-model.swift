import Foundation
import RealmSwift

class AyahTranslit: Object {
    @objc dynamic var transcriptId: String = ""
    @objc dynamic var aya: Int = 0
    @objc dynamic var langCode: String = ""
    @objc dynamic var text: String = ""

    override static func primaryKey() -> String? {
        return "transcriptId"
    }
}

class MetaHizb: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var sura: Int = 0
    @objc dynamic var aya: Int = 0

    override static func primaryKey() -> String? {
        return "index"
    }
}

class MetaJuz: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var sura: Int = 0
    @objc dynamic var aya: Int = 0

    override static func primaryKey() -> String? {
        return "index"
    }
}

class MetaManzil: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var sura: Int = 0
    @objc dynamic var aya: Int = 0

    override static func primaryKey() -> String? {
        return "index"
    }
}

class MetaQuranPage: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var sura: Int = 0
    @objc dynamic var aya: Int = 0

    override static func primaryKey() -> String? {
        return "index"
    }
}

class MetaRuku: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var sura: Int = 0
    @objc dynamic var aya: Int = 0

    override static func primaryKey() -> String? {
        return "index"
    }
}

class MetaSajda: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var sura: Int = 0
    @objc dynamic var aya: Int = 0
    @objc dynamic var type: String = ""

    override static func primaryKey() -> String? {
        return "index"
    }
}

class MetaSurah: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var ayas: Int = 0
    @objc dynamic var start: Int = 0
    @objc dynamic var order: Int = 0
    @objc dynamic var rukus: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var tname: String = ""
    @objc dynamic var ename: String = ""
    @objc dynamic var type: String = ""

    override static func primaryKey() -> String? {
        return "index"
    }
}

class QuranAyah: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var ayat: Int = 0
    @objc dynamic var surahId: Int = 0
    @objc dynamic var pageStart: Int = 0
    @objc dynamic var arabicTextJson: String = ""
    @objc dynamic var notes: String = ""

    override static func primaryKey() -> String? {
        return "index"
    }
    
    var arabicText: String {
        let jsonData = Data(arabicTextJson.utf8)
        let decoder = JSONDecoder()

        do {
            let arabic = try decoder.decode(Arabic.self, from: jsonData)
            return arabic.textAlt ?? arabic.text
        } catch {
            return ""
        }
    }
}

struct Arabic: Codable {
    let text: String
    let textAlt: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "0"
        case textAlt = "1"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.textAlt = try container.decodeIfPresent(String.self, forKey: .textAlt)
    }
}

class QuranTranslit: Object {
    @objc dynamic var transcriptId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var langCode: String = ""
    @objc dynamic var languageTitle: String = ""

    override static func primaryKey() -> String? {
        return "transcriptId"
    }
}

