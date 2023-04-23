//
//  BookmarkList.swift
//  QuranSearch
//
//  Created by ibnu on 23/04/23.
//

import Foundation

import SwiftUI
import RealmSwift

struct BookmarkListView: View {
    @State var verses: [SearchResult] = []
    @State var selectedVerse: SearchResult = SearchResult()
    @State var tapped: Bool = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                List() {
                    ForEach(verses) { verse in
                        VerseCellView(keyword:"", verse: verse).onTapGesture {
                            selectedVerse = verse
                            tapped = true
                        }.listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                NavigationLink("Custom Title", isActive: $tapped) {
                    VerseDetailView(verseId: selectedVerse.verseNumber, chapterId: selectedVerse.chapterNumber, keyword: "")
                }.hidden().frame(width: 0, height: 0, alignment: .bottomLeading)
            }.navigationTitle("Bookmark")
        }.onAppear {
            var result: [SearchResult] = []
            let bookmarks = localRealm.objects(Bookmark.self)
            for bookmark in bookmarks {
                if let chapter = localRealm.objects(Chapter.self).first(where:{ $0.chapterId == bookmark.chapterId }), let verse = chapter.verses.first(where: { $0.verseId == bookmark.verseId }) {
                    result.append(
                        SearchResult(
                            verse: verse.translation,
                            verseNumber: verse.verseId,
                            chapterName: chapter.transliteration,
                            chapterNumber: chapter.chapterId,
                            chapterArabic: chapter.name,
                            chapterTranslation: chapter.translation
                        )
                    )
                }
            }
            verses = result
        }.tint(.white)
    }
}
