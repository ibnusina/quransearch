//
//  VerseCellView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 04/09/22.
//

import SwiftUI

struct VerseCellView: View {
    let keyword: String
    let verse: SearchResult
    
    var body: some View {
        HStack(spacing: 4){
            VStack(alignment: .leading, spacing: 4){
                Text("Chapter \(verse.chapterNumber) (\(verse.chapterName)/\(verse.chapterTranslation))").font(.system(size: 12, weight: .bold, design: .default))
                Text("Verse \(verse.verseNumber)").font(.system(size: 12, weight: .bold, design: .default))
                Text(verse.verse) { text in
                    if let range = text.range(of: keyword, options: .caseInsensitive) {
                        text[range].backgroundColor = Color(UIColor.systemGray)
                    }
                }.multilineTextAlignment(.leading).lineLimit(2).padding(.init(top: 0, leading: 0, bottom: 4, trailing: 0))
                
            }
            Spacer(minLength: 0)
        }.padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
        
    }
}

struct VerseCellView_Previews: PreviewProvider {
    static var previews: some View {
        VerseCellView(keyword:"sd", verse: SearchResult(verse: "sdfsdfsdf\nsdfsdfsdfs sfdsdfsdf sfsdfsdfsdfsdfsdf dfsdfsdfsdfsdfsdf", verseNumber: 1, chapterName: "sdfsdfsdfds", chapterNumber: 1, chapterArabic: "sdfsdf", chapterTranslation: "sdfsdfs"))
    }
}


struct SearchResult: Identifiable, Equatable {
    var id: String {
        "\(chapterNumber)-\(verseNumber)"
    }
    
    let verse: String
    let verseNumber: Int
    let chapterName: String
    let chapterNumber: Int
    let chapterArabic: String
    let chapterTranslation: String
    
    init(
        verse: String = "",
        verseNumber: Int = 0,
        chapterName: String = "",
        chapterNumber: Int = 0,
        chapterArabic: String = "",
        chapterTranslation: String = ""
    ) {
        self.verse = verse
        self.verseNumber = verseNumber
        self.chapterName = chapterName
        self.chapterNumber = chapterNumber
        self.chapterArabic = chapterArabic
        self.chapterTranslation = chapterTranslation
    }
}



/// extension to make applying AttributedString even easier
extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string) /// create an `AttributedString`
        configure(&attributedString) /// configure using the closure
        self.init(attributedString) /// initialize a `Text`
    }
}
