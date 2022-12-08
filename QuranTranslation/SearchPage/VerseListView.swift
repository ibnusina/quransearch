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
    @State var language = "\("language_navigation".localized()): \(UserDefaults.getLanguage().flag)"
    @State var verses: [SearchResult] = []
    @State var selectedVerse: SearchResult = SearchResult()
    @State var tapped: Bool = false
    @State var currentPage: Int = 0
    @State var totalVerse: Int = 0
    @State var sheetPresented: Bool = false
    @State var selectedLanguage: LanguageDirectory = UserDefaults.getLanguage()
    let languages = translationLanguages
    let pageSize = 10
    
    public init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = UIColor(Color.primaryBlue)

        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchQuery, onChange: { newValue in
                    currentPage = 0
                    verses = searchVerse(newValue, page: currentPage, pageSize: pageSize)
                }).tint(.gray)
                Color(Color.primaryBlue.cgColor!).frame(height:8)
                if verses.count > 0 {
                    ZStack{
                        Text(String(format: "result_count".localized(), searchQuery, totalVerse)).foregroundColor(.white).padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    }.frame(maxWidth: .infinity)
                        .background(Color.secondaryBlue)
                }
                List(verses) { verse in
                    if let lastElement = verses.last, verse == lastElement {
                        VerseCellView(keyword:searchQuery, verse: verse).onTapGesture {
                            selectedVerse = verse
                            tapped = true
                        }.onAppear {
                            if verses.count != totalVerse {
                                let newVerses = searchVerse(searchQuery, page: currentPage + 1, pageSize: pageSize)
                                if newVerses.count > 0 {
                                    verses.append(contentsOf: newVerses)
                                    currentPage += 1
                                }
                            }
                        }.listRowInsets(EdgeInsets())
                    } else {
                        VerseCellView(keyword:searchQuery, verse: verse).onTapGesture {
                            selectedVerse = verse
                            tapped = true
                        }.listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Quran Search", displayMode: .automatic)
                .navigationBarItems(
                    trailing: Button(action: {
                        sheetPresented = true
                    }) {
                        Text(language)
                    }.sheet(isPresented: $sheetPresented, content: {
                        Text("choose_language".localized())
                        List(languages) { language in
                            HStack {
                                Text(language.flag)
                                Text(language.name)
                                Color.white
                                Text("\(language == selectedLanguage ? " ✅": "")")
                            }.onTapGesture {
                                sheetPresented = false
                                if (language != selectedLanguage) {
                                    loadLanguage(language)
                                    self.language = "\("language_navigation".localized()): \(language.flag)"
                                    self.selectedLanguage = language
                                }
                            }
                        }
                    })
                )
                
                NavigationLink("Custom Title", isActive: $tapped) {
                    VerseDetailView(verseId: selectedVerse.verseNumber, chapterId: selectedVerse.chapterNumber, keyword: searchQuery)
                }.hidden().frame(width: 0, height: 0, alignment: .bottomLeading)
            }
        }.tint(.white)
    }
    
    func searchVerse(_ keyword: String, page: Int, pageSize: Int) -> [SearchResult] {
        var result: [SearchResult] = []
        let verses = localRealm.objects(Verse.self).filter("translation contains[c] %@", keyword)
        totalVerse = verses.count
        
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
