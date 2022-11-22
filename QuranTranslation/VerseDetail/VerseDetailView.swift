//
//  AyahDetailView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/10/22.
//

import SwiftUI

internal struct VerseDetailView: View {
    @State var verseDetail: VerseDetail
    
    internal init(verseId: Int, chapterId: Int) {
        if let chapter = localRealm.objects(Chapter.self).first(where: { chapter in chapter.chapterId == chapterId }),
           let verse = chapter.verses.first(where: { verse in verse.verseId == verseId }) {
            verseDetail = VerseDetail(
                chapterNumber: chapter.chapterId,
                chapterName: chapter.translation,
                chapterArabic: chapter.name,
                chapterTranslation: chapter.translation,
                verseNumber: verse.verseId,
                verseArabic: verse.text,
                verseTranslation: verse.translation
            )
        } else {
            verseDetail = VerseDetail()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text(verseDetail.verseTranslation).frame(maxWidth: .infinity, alignment: .leading)
                Text(verseDetail.verseArabic).frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
        }.navigationTitle("Chapter \(verseDetail.chapterNumber): \(verseDetail.chapterName)")
            .navigationBarTitleDisplayMode(.inline)
    }
}

internal struct VerseDetail {
    internal let chapterNumber: Int
    internal let chapterName: String
    internal let chapterArabic: String
    internal let chapterTranslation: String
    internal let verseNumber: Int
    internal let verseArabic: String
    internal let verseTranslation: String
    
    init(
        chapterNumber: Int = 0,
        chapterName: String = "",
        chapterArabic: String = "",
        chapterTranslation: String = "",
        verseNumber: Int = 0,
        verseArabic: String = "",
        verseTranslation: String = ""
    ) {
        self.chapterNumber = chapterNumber
        self.chapterName = chapterName
        self.chapterArabic = chapterArabic
        self.chapterTranslation = chapterTranslation
        self.verseNumber = verseNumber
        self.verseArabic = verseArabic
        self.verseTranslation = verseTranslation
    }
}

struct AyahDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VerseDetailView(verseId: 1, chapterId: 1)
    }
}
