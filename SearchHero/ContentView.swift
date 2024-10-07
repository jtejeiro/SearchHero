//
//  ContentView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MyNavigation {
           NavegationTabView()
        }
    }
}

#Preview {
    ContentView()
}
