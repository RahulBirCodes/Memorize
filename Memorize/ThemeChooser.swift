//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Rahul Bir on 7/24/22.
//

import SwiftUI

struct ThemeChooser: View {
    
    @EnvironmentObject var store: ThemeStore
    @State var themeToEdit: Theme?
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        listOfThemes
    }
    
    private func indexOfThemeToEdit(_ theme: Theme) -> Int {
        if let index = store.themes.firstIndex(of: theme) {
            return index
        } else {
            return 0
        }
    }
    
    var listOfThemes: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(theme.name)
                                    .font(.title)
                                    .foregroundStyle(LinearGradient(topToBottomLinearGradient: theme.fill))
                                Text(theme.emojiSet.joined(separator: ""))
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .alert(item: $alertToShow) { alertToShow in
                            alertToShow.alert()
                        }
                    }
                    .disabled(theme.emojiSet.count < 2)
                    .gesture(editMode != .active && theme.emojiSet.count < 2 ? throwAlertGesture() : nil)
                    .simultaneousGesture(editMode == .active ? openThemeEditor(for: theme) : nil)
                    .sheet(item: $themeToEdit) { theme in
                        ThemeEditor(theme: $store.themes[indexOfThemeToEdit(theme)])
                    }
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Themes")
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) { newThemeButton }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    var newThemeButton: some View {
        Button {
            store.insertTheme(name: "Name",
                              emojis: "",
                              fill: TopToBottomLinearGradient(colors: [Color(red: 0, green: 0, blue: 0)]),
                              pairsOfCards: 0)
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private func openThemeEditor(for theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded { _ in
                themeToEdit = theme
            }
    }
    
    @State private var alertToShow: IdentifiableAlert?
    
    private func showInvalidThemeAlert() {
        alertToShow = IdentifiableAlert(id: UUID().uuidString, alert: {
            Alert(
                title: Text("Game Creation"),
                message: Text("Theme is invalid, needs to have at least two emojis"),
                dismissButton: .default(Text("OK")))
        })
    }
    
    private func throwAlertGesture() -> some Gesture {
        TapGesture()
            .onEnded { _ in
                showInvalidThemeAlert()
            }
    }
}






























struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser().environmentObject(ThemeStore())
    }
}
