//
//  ChapterListView.swift
//  QuranSearch
//
//  Created by ibnu on 24/04/23.
//

import Foundation
import SwiftUI
import Realm

struct ChapterListView: View {
    @State private var showDetails: [Bool] = Array(repeating: false, count: 114)
    @State private var verseGroups: [VerseGroup] = []
    @State var tapped: Bool = false
    
    @State private var selectedChapter: Int = 0
    @State private var selectedVerse: Int = 0
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                List {
                    ForEach(verseGroups) { group in
                        DisclosureGroup(group.chapterText, isExpanded: $showDetails[group.chapterId-1]) {
                            Text("\("verses".localized().capitalized):").listRowSeparator(.hidden).padding(.top, -12)
                            ForEach(group.versesItems) { row in
                                HStack {
                                    ForEach(row.texts) { verseText in
                                        Text(verseText).onTapGesture {
                                            selectedVerse = Int(verseText) ?? 0
                                            selectedChapter = group.chapterId
                                            tapped = true
                                        }.font(.system(size: 16, weight: .bold, design: .default))
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                                            .background(
                                                RoundedRectangle(cornerRadius: 8, style:.continuous)
                                                .fill(Color.actionTeal)
                                            )
                                    }
                                }.listRowSeparator(row.showSeparator ? .visible : .hidden)
                            }
                        }.tint(.gray)
                    }
                    
                    
                }.listStyle(PlainListStyle())
                NavigationLink("Custom Title", isActive: $tapped) {
                    VerseDetailView(verseId: selectedVerse, chapterId: selectedChapter, keyword: "")
                }.hidden().frame(width: 0, height: 0, alignment: .bottomLeading)
            }.navigationTitle("chapter".localized())
        }.tint(.white)
            .onAppear {
                let chapters = localRealm.objects(Chapter.self)
                var groups: [VerseGroup] = []
                for chapter in chapters {
                    var group = VerseGroup()
                    group.chapterId = chapter.chapterId
                    group.chapterText = "\(chapter.chapterId)) \(chapter.transliteration) (\(chapter.translation))"
                    let columnCount = 5
                    let totalRow = Int(ceil(Float(chapter.verses.count)/Float(columnCount)))
                    for row in 0 ..< totalRow {
                        var verses: [String] = []
                        for column in 0 ..< (((chapter.verses.count - row * columnCount)) >= columnCount ? columnCount : (chapter.verses.count % columnCount)) {
                            verses.append("\(row * columnCount + column + 1)")
                        }
                        group.versesItems.append(VersesItem(texts: verses, showSeparator: row+1 == totalRow))
                    }
                    groups.append(group)
                }
                verseGroups = groups
            }.tint(.white)
    }
}

struct VerseGroup: Identifiable {
    public var id: String {
        "\(chapterText)"
    }
    
    var chapterId: Int = 0
    var chapterText: String = ""
    var versesItems: [VersesItem] = []
}

struct VersesItem: Identifiable {
    public var id: String {
        "\(texts.first ?? "")"
    }
    
    var texts: [String]
    var showSeparator: Bool
    
}

extension [String]: Identifiable {
    public var id: String {
        "\(self.first?.description ?? "")"
    }
}

extension String: Identifiable {
    public var id: String {
        self.description
    }
}
