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
    let keyword: String
    @State private var prevTitle: String = ""
    @State private var nextTitle: String = ""

    @State var viewDidLoad: Bool = false
    
    
    internal init(verseId: Int, chapterId: Int, keyword: String) {
        self.verseId = verseId
        self.chapterId = chapterId
        self.keyword = keyword
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
                prevTitle = "← \("to_chapter".localized()) \(chapterId - 1)"
            } else if verseId > 1 {
                prevTitle = "← \("to_verse".localized()) \(verseId - 1)"
            } else {
                prevTitle = ""
            }

            if verseId == lastVerseId && chapterId != lastChapterId {
                nextTitle = "\("to_chapter".localized()) \(chapterId + 1) →"
            } else if verseId < lastVerseId {
                nextTitle = "\("to_verse".localized()) \(verseId + 1) →"
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
            VStack(spacing: 12) {
                ZStack{
                    Text("\("verse".localized()) \(verseDetail.verseNumber)").padding(.top, 12).foregroundColor(.white)
                }.frame(maxWidth: .infinity)
                    .background(Color.secondaryBlue)
                
                ScrollView {
                    VStack(spacing: 0) {
                        Text(verseDetail.verseTranslation){ text in
                            if let range = text.range(of: keyword, options: .caseInsensitive) {
                                text[range].backgroundColor = Color(UIColor.systemGray)
                            }
                        }.multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                        Text(verseDetail.verseArabic)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
                    }
                }.background(Color.white)
                HStack(spacing: 20){
                    ZStack {
                        Color(Color.actionTeal.cgColor!)
                        Button() {
                            goToPrev()
                        } label: {
                            Text(prevTitle).frame(maxWidth: .infinity).padding(.all, 12).font(.system(size: 16, weight: .bold, design: .default))
                        }
                    }.cornerRadius(8, corners: [.topRight, .bottomRight]).opacity(prevTitle == "" ? 0 : 1)
                    
                    ZStack {
                        Color(Color.actionTeal.cgColor!)
                        Button() {
                            goToNext()
                        } label: {
                            Text(nextTitle).frame(maxWidth: .infinity).padding(.all, 12).font(.system(size: 16, weight: .bold, design: .default))
                        }
                    }.cornerRadius(8, corners: [.topLeft, .bottomLeft]).opacity(nextTitle == "" ? 0 : 1)
                    
                }.frame(maxWidth:.infinity, idealHeight: 40, maxHeight: 40).padding(.bottom, 12)
            }.background(Color.secondaryBlue)
        }.navigationTitle("\("chapter".localized()) \(verseDetail.chapterNumber): \(verseDetail.chapterName)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                onViewDidLoad()
            }.tint(.white)
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
        VerseDetailView(verseId: 1, chapterId: 1, keyword: "abc")
    }
}
