//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Rahul Bir on 7/26/22.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                colorPicker
                removeEmojisSection
                addEmojiSection
                setPairsOfCardsSection
            }
            .navigationTitle("Edit " + theme.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if presentationMode.wrappedValue.isPresented,
                       UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    var nameSection: some View {
        Section {
            TextField("Name", text: $theme.name)
        } header: {
            Text("THEME NAME")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }

    @State var color: Color
    
    init(theme: Binding<Theme>) {
        self._theme = theme
        self._color = .init(initialValue: Color(rgbaColor: theme.wrappedValue.fill.colors[0]))
    }

    var colorPicker: some View {
        Section {
            ColorPicker(selection: $color) {
                HStack {
                    Text("Main Color")
                }
            }
            .onChange(of: color) { newColor in
                theme.fill.colors[0] = RGBAColor(color: newColor)
            }
        } header: {
            HStack {
                Text("COLOR")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                Image(systemName: "eyedropper.halffull")
            }
        }
    }
    
    @State var emojisToAdd = ""
    
    func addEmojis(_ emojis: String) {
        let emojiString = (emojisToAdd + theme.emojiSet.joined(separator: ""))
            .filter { $0.isEmoji }
            .removingDuplicateCharacters
        theme.emojiSet = emojiString.map({String($0)})
    }
    
    var addEmojiSection: some View {
        Section {
            TextField("Emojis...😁🤯🥶", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { addEmojis($0) }
        } header: {
            Text("ADD EMOJIS")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }
    
    var removeEmojisSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojiSet, id: \.self) { emoji in
                    Text(emoji).padding(1)
                        .onTapGesture {
                            withAnimation {
                                theme.emojiSet.removeAll(where: {$0 == emoji})
                            }
                        }
                }
            }
            .font(.system(size: 40))
        } header: {
            HStack {
                Text("REMOVE EMOJIS")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                Spacer()
                Text("TAP TO REMOVE")
            }
        }
    }
    
    var setPairsOfCardsSection: some View {
        Section {
            Stepper(value: $theme.pairsOfCards, in: min(2, theme.emojiSet.count)...theme.emojiSet.count) {
                Text(String(theme.pairsOfCards) + " cards")
            }
        } header: {
            Text("CARD DECK COUNT")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }
}





















struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore().themes[0]))
    }
}
