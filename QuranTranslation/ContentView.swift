//
//  ContentView.swift
//  QuranTranslation
//
//  Created by ibnu.sina on 17/08/22.
//

import SwiftUI

struct ContentView: View {
    @State var searchQuery = ""
    @State var language = "Bahasa: 🇮🇩"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {}.navigationBarTitle("Activities")
            }
            .navigationBarItems(
                trailing: Button(action: {}) {
                    Text(language)
                })
            .searchable(text: $searchQuery)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
