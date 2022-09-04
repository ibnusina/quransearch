//
//  VerseCellView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 04/09/22.
//

import SwiftUI

struct VerseCellView: View {
    let verse: SearchResult
    
    var body: some View {
        HStack(spacing: 4){
            VStack(alignment: .leading, spacing: 4){
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("Verse \(verse.verseNumber) of Chapter \(verse.chapterNumber) (\(verse.chapterName)/\(verse.chapterTranslation))").font(.system(size: 12, weight: .bold, design: .rounded))
                }
                Text(verse.verse).multilineTextAlignment(.leading).lineLimit(2).padding(.init(top: 0, leading: 0, bottom: 4, trailing: 0))
                
            }
            Spacer(minLength: 4)
            NavigationLink(destination: Text("Somewhere")) {
                EmptyView()
            }.frame(width: 20, height: 40, alignment: .center)
        }.padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
        
    }
}

struct VerseCellView_Previews: PreviewProvider {
    static var previews: some View {
        VerseCellView(verse: SearchResult(verse: "sdfsdfsdf\nsdfsdfsdfs sfdsdfsdf sfsdfsdfsdfsdfsdf dfsdfsdfsdfsdfsdf", verseNumber: 1, chapterName: "sdfsdfsdfds", chapterNumber: 1, chapterArabic: "sdfsdf", chapterTranslation: "sdfsdfs"))
    }
}


struct SearchResult: Identifiable {
    var id: String {
        "\(chapterNumber)-\(verseNumber)"
    }
    
    let verse: String
    let verseNumber: Int
    let chapterName: String
    let chapterNumber: Int
    let chapterArabic: String
    let chapterTranslation: String
}
