//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Rahul Bir on 7/24/22.
//

import SwiftUI

struct ThemeChooser: View {
    
    @EnvironmentObject var store: ThemeStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .font(.title)
                                .foregroundStyle(LinearGradient(topToBottomLinearGradient: theme.fill))
                            Text(theme.emojiSet.joined(separator: ""))
                                .lineLimit(1)
                        }
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
            .navigationTitle("Themes")
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("clicked")
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
        }
    }
}






























struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser().environmentObject(ThemeStore())
    }
}
