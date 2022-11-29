//
//  AyahDetailView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/10/22.
//

import SwiftUI

internal struct VerseDetailView: View {
    @State var verseDetail: VerseDetail = VerseDetail()
    @State var verseId: Int
    @State var chapterId: Int
    @State private var prevTitle: String = ""
    @State private var nextTitle: String = ""

    @State var viewDidLoad: Bool = false
    
    
    internal init(verseId: Int, chapterId: Int) {
        self.verseId = verseId
        self.chapterId = chapterId
    }
    
    private func onViewDidLoad() {
        guard !viewDidLoad else { return }
        viewDidLoad = true
        
        updateView()
    }
    
    
    private func updateView() {
        if let chapter = localRealm.objects(Chapter.self).first(where: { chapter in chapter.chapterId == chapterId }),
           let verse = chapter.verses.first(where: { verse in verse.verseId == verseId }),
           let lastChapterId = localRealm.objects(Chapter.self).last?.chapterId,
           let lastVerseId = chapter.verses.last?.verseId {
            verseDetail = VerseDetail(
                chapterNumber: chapter.chapterId,
                chapterName: chapter.translation,
                chapterArabic: chapter.name,
                chapterTranslation: chapter.translation,
                verseNumber: verse.verseId,
                verseArabic: verse.text,
                verseTranslation: verse.translation
            )
            
            if verseId == 1 && chapterId != 1 {
                prevTitle = "to chapter \(chapterId - 1)"
                if let prevChapterVerseId = localRealm.objects(Chapter.self).last(where: { chapter in chapter.chapterId == (chapterId - 1) })?.verses.last?.verseId {

                }
            } else if verseId > 1 {
                prevTitle = "to verse \(verseId - 1)"
            } else {
                prevTitle = ""
            }

            if verseId == lastVerseId && chapterId != lastChapterId {
                nextTitle = "to chapter \(chapterId + 1)"
            } else if verseId < lastVerseId {
                nextTitle = "to verse \(verseId + 1)"
            } else {
                nextTitle = ""
            }
        } else {
            verseDetail = VerseDetail()
        }
    }
    
    private func goToPrev() {
        if verseId == 1 && chapterId != 1 {
            if let prevChapterVerseId = localRealm.objects(Chapter.self).last(where: { chapter in chapter.chapterId == (chapterId - 1) })?.verses.last?.verseId {
                chapterId -= 1
                verseId = prevChapterVerseId
                updateView()
            }
        } else if verseId > 1 {
            verseId -= 1
            updateView()
        }
    }
    
    private func goToNext() {
        if let chapter = localRealm.objects(Chapter.self).first(where: { chapter in chapter.chapterId == chapterId }),
           let lastChapterId = localRealm.objects(Chapter.self).last?.chapterId,
           let lastVerseId = chapter.verses.last?.verseId {
            
            if verseId == lastVerseId && chapterId != lastChapterId {
                chapterId += 1
                verseId = 1
                updateView()
            } else if verseId < lastVerseId {
                verseId += 1
                updateView()
            }
            
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 8) {
                        Text(verseDetail.verseTranslation).frame(maxWidth: .infinity, alignment: .leading)
                        Text(verseDetail.verseArabic).frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                HStack{
                    Button(prevTitle, role: nil) {
                        goToPrev()
                    }
                    Spacer()
                    Text("verse: \(verseDetail.verseNumber)")
                    Spacer()
                    Button(nextTitle, role: nil) {
                        goToNext()
                    }
                }
            }
        }.navigationTitle("Chapter \(verseDetail.chapterNumber): \(verseDetail.chapterName)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                onViewDidLoad()
            }
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
