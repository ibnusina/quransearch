//
//  ContentView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/08/22.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State var searchQuery = ""
    @State var language = "Bahasa: 🇮🇩"
    @State var verses: [SearchResult] = []
    
    var body: some View {
        NavigationView {
            List(verses) { verse in
                VerseCellView(keyword:searchQuery, verse: verse)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Quran Search")
            .navigationBarItems(
                trailing: Button(action: {}) {
                    Text(language)
                })
            .searchable(text: $searchQuery).onChange(of: searchQuery) { newValue in
                verses = searchVerse(newValue, page: 1, pageSize: 10)
            }
            
            
        }
    }
    
    func searchVerse(_ keyword: String, page: Int, pageSize: Int) -> [SearchResult] {
        var result: [SearchResult] = []
        let verses = localRealm.objects(Verse.self).filter("translation contains[c] %@", keyword)
        
        for i in 0..<pageSize {
            let index = i*page
            guard index < verses.count else { break }
            let verse = verses[index]
            if let chapter = localRealm.objects(Chapter.self).where({ $0.verses.contains(verse) }).first {
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
        ContentView()
    }
}
