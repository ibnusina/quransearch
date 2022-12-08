//
//  SearchBar.swift
//  QuranTranslation
//
//  Created by ibnu on 08/12/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    @State var onChange: (String) -> Void
    
    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.text = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 16)
                .onTapGesture {
                    self.isEditing = true
                }
                .onChange(of: text) { newValue in
                    onChange(newValue)
                }
        }.background(Color.primaryBlue)
        
    }
}
