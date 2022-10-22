//
//  AyahDetailView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/10/22.
//

import SwiftUI

struct VerseDetailView: View {
    @State var verseDetail: VerseDetail
    
    init(verseId: Int, chapterId: Int) {
        if let chapter = localRealm.objects(Chapter.self).first(where: { chapter in chapter.chapterId == chapterId }),
           let verse = chapter.verses.first(where: { verse in verse.verseId == verseId }) {
            verseDetail = VerseDetail(chapterNumber: chapter.chapterId, verseNumber: verse.verseId)
        } else {
            verseDetail = VerseDetail(chapterNumber: 3, verseNumber: 3)
        }
    }
    
    var body: some View {
        
        Text("\(verseDetail.chapterNumber) - \(verseDetail.verseNumber)")
        
    }
}

struct VerseDetail {
    let chapterNumber: Int
    let verseNumber: Int
}

struct AyahDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VerseDetailView(verseId: 1, chapterId: 1)
    }
}
