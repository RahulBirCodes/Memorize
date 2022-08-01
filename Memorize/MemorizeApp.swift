//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Rahul Bir on 6/10/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore()
    
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
