//
//  ContentView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/08/22.
//

import SwiftUI
import RealmSwift

struct VerseListView: View {
    @State var searchQuery = ""
    @State var language = "Bahasa: 🇮🇩"
    @State var verses: [SearchResult] = []
    @State var selectedVerse: SearchResult = SearchResult()
    @State var tapped: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(verses) { verse in
                    VerseCellView(keyword:searchQuery, verse: verse).onTapGesture {
                        selectedVerse = verse
                        tapped = true
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Quran Search")
                .navigationBarItems(
                    trailing: Button(action: {}) {
                        Text(language)
                    })
                .searchable(text: $searchQuery).onChange(of: searchQuery) { newValue in
                    verses = searchVerse(newValue, page: 0, pageSize: 10)
                }
                NavigationLink("", isActive: $tapped) {
                    VerseDetailView(verseId: selectedVerse.verseNumber, chapterId: selectedVerse.chapterNumber)
                }.hidden().frame(width: 0, height: 0, alignment: .bottomLeading)
            }
        }
    }
    
    func searchVerse(_ keyword: String, page: Int, pageSize: Int) -> [SearchResult] {
        var result: [SearchResult] = []
        let verses = localRealm.objects(Verse.self).filter("translation contains[c] %@", keyword)
        
        for index in (page * pageSize)..<pageSize * (page + 1) {
            guard index < verses.count else { break }
            let verse = verses[index]
            if let chapter = localRealm.objects(Chapter.self).first(where: { chapter in chapter.verses.contains(verse) }) {
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
        
        return result
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VerseListView()
    }
}
